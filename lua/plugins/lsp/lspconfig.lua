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
            'openscad_lsp',
        })

        require('mason-lspconfig').setup({
            --ensure_installed = lsp_servers,
            --automatic_installation = true,
            automatic_enable = lsp_servers,
        })

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

        -- 改进：使用 LspAttach 在每个 buffer 上创建 buffer-local augroup，精确管理诊断浮窗
        local float_win_by_buf = {}
        local last_open_time = {}
        local MIN_OPEN_INTERVAL_MS = 150

        local function close_buf_float(bufnr)
            local win = float_win_by_buf[bufnr]
            if win and vim.api.nvim_win_is_valid(win) then
                pcall(vim.api.nvim_win_close, win, true)
            end
            float_win_by_buf[bufnr] = nil
            last_open_time[bufnr] = nil
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client_id = args.data and args.data.client_id
                if not client_id then
                    return
                end

                -- 跳过非普通 buffer（terminal / nofile 等）
                local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
                if buftype ~= "" then
                    return
                end

                local augroup = vim.api.nvim_create_augroup("NVCodeLspDiagFloat" .. bufnr, { clear = true })

                vim.api.nvim_create_autocmd({ "CursorHold" }, {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- 不在插入模式时显示
                        if vim.fn.mode() == "i" then
                            return
                        end

                        -- 节流：避免快速重复打开
                        local now = vim.loop.now()
                        if last_open_time[bufnr] and (now - last_open_time[bufnr] < MIN_OPEN_INTERVAL_MS) then
                            return
                        end

                        -- 仅当当前行有诊断时才打开浮窗
                        local cursor = vim.api.nvim_win_get_cursor(0)
                        local line = cursor[1] - 1
                        local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
                        if vim.tbl_isempty(diagnostics) then
                            close_buf_float(bufnr)
                            return
                        end

                        -- 如果已有有效浮窗则不重复打开
                        local existing = float_win_by_buf[bufnr]
                        if existing and vim.api.nvim_win_is_valid(existing) then
                            return
                        end

                        -- 关闭旧浮窗并打开新浮窗
                        close_buf_float(bufnr)
                        local opts = { focus = false, scope = "cursor" }
                        local ok, win = pcall(vim.diagnostic.open_float, bufnr, opts)
                        if ok and win and vim.api.nvim_win_is_valid(win) then
                            float_win_by_buf[bufnr] = win
                            last_open_time[bufnr] = now
                            -- 使用布尔标记（pcall 以防失败）
                            pcall(vim.api.nvim_win_set_var, win, "diagnostic_float", true)
                        end
                    end,
                })

                -- 在这些事件发生时关闭该 buffer 的浮窗
                vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave", "BufWinLeave" }, {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        close_buf_float(bufnr)
                    end,
                })
            end,
        })
    end,
}
