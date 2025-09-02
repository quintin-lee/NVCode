return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'ray-x/lsp_signature.nvim',
        'tjdevries/nlua.nvim',
        'hrsh7th/nvim-cmp',
        {
            'salkin-mada/openscad.nvim',
            dependencies = { 'L3MON4D3/LuaSnip', build = "make install_jsregexp" },
        },
    },

    lazy = false,
    config = function()
        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- 读取 JSON 配置文件
        local function read_json_config(file)
            local f = assert(io.open(file, "r"))
            local content = f:read("*all")
            f:close()
            return vim.fn.json_decode(content)
        end

        local function concat_dedup(arr1, arr2)
            local merged = {}
            local seen = {}

            -- 处理第一个数组
            for _, v in ipairs(arr1) do
                if not seen[v] then
                    table.insert(merged, v)
                    seen[v] = true
                end
            end

            -- 处理第二个数组
            for _, v in ipairs(arr2) do
                if not seen[v] then
                    table.insert(merged, v)
                    seen[v] = true
                end
            end

            return merged
        end

        -- 加载 LSP 配置
        local lsp_config = read_json_config(vim.fn.stdpath("config") .. "/lua/configs/lsp_config.json")

        local user_lsp_servers = vim.tbl_keys(lsp_config)
        local lsp_servers = concat_dedup(user_lsp_servers, {
            'bashls',
            'lua_ls',
            'jdtls',
            'pylsp',
            'clangd',
            'cmake',
            'rust_analyzer',
            'gopls',
        })

        require('mason-lspconfig').setup({
            --ensure_installed = lsp_servers,
            --automatic_installation = true,
            automatic_enable = lsp_servers,
        })

        -- 加载每个语言的配置
        for _, server in ipairs(lsp_servers) do
            local ok, _ = pcall(require, 'plugins.lsp.langs.' .. server)
            if not ok then
                vim.notify('Failed to load LSP config for ' .. server, vim.log.levels.ERROR)
            end
        end
        require("plugins.lsp.langs")       -- 语言服务器

        for server, config in pairs(lsp_config) do
            if config.enabled then
                vim.lsp.config(server, {
                    settings = config.settings,
                    on_attach = function(client, bufnr)
                        require "lsp_signature".on_attach()
                    end,
                    capabilities = capabilities,
                    single_file_support = true,
                })
                vim.lsp.enable(server)
            end
        end

        vim.diagnostic.config({
            float = {
                border = "double"  -- 可选值有 "single", "double", "rounded", "solid", "shadow"
            }
        })

        -- 创建一个函数来检查并关闭由当前代码创建的悬浮窗口
        local function close_my_float_wins()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) then
                    local config = vim.api.nvim_win_get_config(win)
                    if config.relative ~= "" then
                        local ok, my_float = pcall(vim.api.nvim_win_get_var, win, "diagnostic_float")
                        if ok and my_float == "true" then
                            vim.api.nvim_win_close(win, true)
                        end
                    end
                end
            end
        end

        -- 创建一个函数来标记当前代码创建的悬浮窗口
        local function mark_my_float_win(win_id)
            if vim.api.nvim_win_is_valid(win_id) then
                vim.api.nvim_win_set_var(win_id, "diagnostic_float", "true")
            end
        end

        -- 注册 CursorHold 自动命令
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                close_my_float_wins() -- 关闭由当前代码创建的悬浮窗口
                local opts = { focus = false, scope = "cursor" }
                local win_id = vim.diagnostic.open_float(nil, opts)
                if win_id then
                    mark_my_float_win(win_id) -- 标记当前代码创建的悬浮窗口
                end
            end
        })
    end,
}
