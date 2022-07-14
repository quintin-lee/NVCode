local dap = require('dap')
local home = os.getenv('HOME')

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = home .. '/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

if dap.configurations.cppdbg then
    dap.configurations.cpp = dap.configurations.cppdbg
else
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
        },
        {
            name = 'Attach to gdbserver',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = function()
                return vim.fn.input('localhost:', '')
            end,
            miDebuggerPath = home .. '/.local/bin/ngdb',
            cwd = '${workspaceFolder}',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
        },
        {
            name = 'Attach process',
            type = 'cppdbg',
            request = 'attach',
            MIMode = 'gdb',
            processId = function()
                return vim.fn.input('processId:', '', 'var')
            end,
            miDebuggerPath = home .. '/.local/bin/ngdb',
            cwd = '${workspaceFolder}',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
        }
    }
end

dap.configurations.c = dap.configurations.cpp
dap.configurations.c = dap.configurations.cpp
