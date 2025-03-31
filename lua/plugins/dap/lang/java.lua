local dap = require('dap')

local data_home = vim.fn.stdpath("data")

dap.adapters.java = {
  type = 'executable',
  command = 'java',
  args = { '-jar', vim.fn.expand(data_home .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar') }
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'launch',
    name = 'Launch Main Class',
    mainClass = function()
      -- 动态解析主类
      return require('jdtls').resolve_main_class()
    end,
    cwd = vim.fn.getcwd(),
  }
}

