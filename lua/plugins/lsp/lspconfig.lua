return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "ray-x/lsp_signature.nvim",
        "tjdevries/nlua.nvim",
        "hrsh7th/nvim-cmp",
        {
            "salkin-mada/openscad.nvim",
            dependencies = { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
        },
    },

    lazy = false,
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
            "bashls",
            "lua_ls",
            "jdtls",
            "pylsp",
            "clangd",
            "cmake",
            "rust_analyzer",
            "gopls",
            "openscad_lsp",
        })

        require("mason-lspconfig").setup({
            --ensure_installed = lsp_servers,
            --automatic_installation = true,
            automatic_enable = lsp_servers,
        })

        for server, config in pairs(lsp_config) do
            if config.enabled then
                -- 1. 强制统一编码变量
                local target_encoding = "utf-8"

                -- 2. 克隆一份全新的 capabilities，防止不同 server 之间互相干扰
                local server_caps = vim.deepcopy(capabilities)
                -- 强制 LSP 握手时只允许使用这一种编码
                server_caps.offsetEncoding = { target_encoding }

                local lsp_opts = {
                    settings = config.settings,
                    capabilities = server_caps,
                    offset_encoding = target_encoding,
                    on_attach = function(client, bufnr)
                        -- 再次强制覆盖客户端属性
                        client.offset_encoding = target_encoding
                        require("lsp_signature").on_attach({}, bufnr)
                    end,
                    single_file_support = true,
                }

                vim.lsp.config(server, lsp_opts)
                vim.lsp.enable(server)
            end
        end

        -- Optimize LSP diagnostics for faster response
        vim.diagnostic.config({
            float = {
                border = "double", -- 可选值有 "single", "double", "rounded", "solid", "shadow"
                source = "always", -- show source with diagnostic
                focusable = false, -- prevent float from stealing focus
            },
            -- Reduce diagnostics updates to improve performance
            update_in_insert = false,
            -- Optimize virtual text settings to improve performance
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●", -- Could use "icons" for more visual indicators
            },
            -- Configure signs for better performance
            signs = true,
            underline = true,
            severity_sort = true,
        })

        -- Improved: Use LspAttach to create buffer-local augroup for precise diagnostics float management
        local float_win_by_buf = {}
        local last_open_time = {}
        local MIN_OPEN_INTERVAL_MS = 200 -- Increased to reduce frequency

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

                -- Skip non-normal buffers (terminal / nofile etc.)
                local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
                if buftype ~= "" then
                    return
                end

                local augroup = vim.api.nvim_create_augroup("NVCodeLspDiagFloat" .. bufnr, { clear = true })

                vim.api.nvim_create_autocmd({ "CursorHold" }, {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- Don't show in insert mode
                        if vim.fn.mode() == "i" then
                            return
                        end

                        -- Throttle: avoid repeated opening
                        local now = vim.loop.now()
                        if last_open_time[bufnr] and (now - last_open_time[bufnr] < MIN_OPEN_INTERVAL_MS) then
                            return
                        end

                        -- Only open when current line has diagnostics
                        local cursor = vim.api.nvim_win_get_cursor(0)
                        local line = cursor[1] - 1
                        local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
                        if vim.tbl_isempty(diagnostics) then
                            close_buf_float(bufnr)
                            return
                        end

                        -- Don't repeat open if already valid window exists
                        local existing = float_win_by_buf[bufnr]
                        if existing and vim.api.nvim_win_is_valid(existing) then
                            return
                        end

                        -- Close old window and open new one
                        close_buf_float(bufnr)
                        local opts = { focus = false, scope = "cursor", border = "double" }
                        local ok, win = pcall(vim.diagnostic.open_float, bufnr, opts)
                        if ok and win and vim.api.nvim_win_is_valid(win) then
                            float_win_by_buf[bufnr] = win
                            last_open_time[bufnr] = now
                            -- Use boolean flag (pcall in case of failure)
                            pcall(vim.api.nvim_win_set_var, win, "diagnostic_float", true)
                        end
                    end,
                })

                -- Close float for this buffer on these events
                vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave", "BufWinLeave" }, {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        close_buf_float(bufnr)
                    end,
                })
            end,
        })

        -- Optimized LSP client settings for faster response
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Only update diagnostics when not in insert mode
            -- This prevents performance issues during typing
            debounce = 200,
            -- Only virtual text on the same line as the cursor
            virtual_text = {
                spacing = 4,
                source = "if_many",
            },
            -- Show signs in the sign column
            signs = true,
            -- Whether to use underline highlights
            underline = true,
            -- Update diagnostics in insert mode
            update_in_insert = false,
        })
    end,
}
