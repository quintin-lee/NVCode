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
        text = "",
        texthl = "LspDiagnosticsSignError",
        linehl = '',
        numhl = ''
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stoped = {
        text = "",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    }
}

vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
vim.fn.sign_define('DapBreakpoint', dap_breakpoint.rejected)
vim.fn.sign_define('DapStopped', dap_breakpoint.stoped)

local home = os.getenv("HOME")

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = home .. '/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

require("configs.dap.cpp")
require("configs.dap.python")

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
