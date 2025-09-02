return {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        'mfussenegger/nvim-dap',
        'ravenxrz/DAPInstall.nvim',
        'mfussenegger/nvim-dap-python',
        'nvim-neotest/nvim-nio',
    },
    event = 'VeryLazy',
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- config and sign
        local dap_breakpoint = {
            breakpoint = {
                text = "🛑",
                texthl = "LspDiagnosticsSignError",
                linehl = '',
                numhl = ''
            },
            rejected = {
                text = "🚫",
                texthl = "LspDiagnosticsSignHint",
                linehl = "",
                numhl = "",
            },
            stoped = {
                text = "👉",
                texthl = "LspDiagnosticsSignInformation",
                linehl = "DiagnosticUnderlineInfo",
                numhl = "LspDiagnosticsSignInformation",
            },
            condition = {
                text = "❓",
                texthl = "LspDiagnosticsSignInformation",
                linehl = "",
                numhl = "",
            },
        }

        vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
        vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
        vim.fn.sign_define('DapStopped', dap_breakpoint.stoped)
        vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)

        -- 支持 .vscode/launch.json
        require('dap.ext.vscode').load_launchjs()

        require("plugins.dap.lang.cpp")
        require("plugins.dap.lang.python")
        require("plugins.dap.lang.java")
        require("plugins.dap.lang.go")

        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            -- Expand lines larger than the window
            -- Requires >= 0.7
            expand_lines = vim.fn.has("nvim-0.7"),
            layouts = {
                {
                    elements = {
                        'scopes',
                        'breakpoints',
                        'stacks',
                        'watches',
                    },
                    size = 40,
                    position = 'left',
                },
                {
                    elements = {
                        'repl',
                        'console',
                    },
                    size = 10,
                    position = 'bottom',
                },
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
                border = "single", -- Border style. Can be "single", "double" or "rounded"
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
            render = {
                max_type_length = nil, -- Can be integer or nil.
            }
        })
    end,
}
