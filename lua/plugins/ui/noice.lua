return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true, -- 输入参数时自动弹出
                    }
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                -- 自定义补全窗口样式
                hover = {
                    enabled = true,
                    silent = false,  -- 不要静默错误
                    view = "hover",  -- 悬浮窗口样式
                },
            },
            cmdline = {
                -- 或保留部分功能但禁用浮动窗口：
                enabled = true,   -- 保持启用，但修改视图模式
                view = "cmdline", -- 使用传统命令行（非浮动窗口）
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
            messages = {
                enabled = true,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages",
                view_search = "virtualtext",
            },
            health = {
                checker = false,
            },
        })
    end
}
