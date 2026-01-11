return {
    "stevearc/conform.nvim",
    event = { "BufReadPre" }, -- Change to BufReadPre to set up formatting before file is read
    opts = {
        formatters_by_ft = {
            -- 1. 原有语言
            go = { "goimports", "gofmt" },
            -- 使用black作为主要Python格式化工具，避免与LSP冲突
            python = { "black", "ruff_organize_imports" },
            c = { "clang-format" },
            cpp = { "clang-format" },

            -- 2. 新增：CUDA (通常使用 clang-format)
            cuda = { "clang-format" },

            -- 3. 新增：Rust (官方推荐 rustfmt)
            rust = { "rustfmt" },

            -- 4. 新增：Lua (开发 Neovim 插件必备)
            lua = { "stylua" },

            -- 5. 新增：前端/通用 (Prettier 支持多种格式)
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },

            -- Add text and help files to prevent accidental formatting
            ["_"] = { "injected" }, -- Only format injected languages for all filetypes
        },
        format_on_save = {
            timeout_ms = 1000,
            lsp_format = "fallback", -- Use LSP as fallback when conform can't format
            -- Only format on save if a formatter is available for the filetype
            function(bufnr)
                local null_ls = require("null-ls")
                local available = require("conform").list_formatters(bufnr)
                local has_null_ls = #null_ls.get_sources({ method = null_ls.methods.FORMATTING }) > 0
                return #available > 0 or has_null_ls
            end,
        },
        -- 针对不同语言的格式化器自定义配置
        formatters = {
            black = {
                -- Black选项配置
                prepend_args = {
                    "--line-length=88", -- 行长度限制
                    "--skip-string-normalization", -- 保留字符串引号格式
                },
            },
            ruff_organize_imports = {
                -- Ruff导入排序配置
                prepend_args = {
                    "--line-length=88",
                },
            },
            ["clang-format"] = {
                -- 如果 CUDA 文件没有被识别，可以强制指定风格
                prepend_args = { "--style=file" },
            },
        },
    },
    init = function()
        -- Set up format on save manually to have better control
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat", { clear = false }),
            callback = function(args)
                -- Only format if the buffer is not modified after the last format
                require("conform").format({
                    bufnr = args.buf,
                    async = false,
                    timeout_ms = 1000,
                }, function(err)
                    if err ~= nil then
                        print("Formatting failed: " .. tostring(err))
                    end
                end)
            end,
        })
    end,
}
