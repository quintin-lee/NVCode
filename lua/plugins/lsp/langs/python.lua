local py_config = require'lspconfig'.pylsp

py_config.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 120,
          indentSize = 4,
          ignore = {'E302', 'E305', 'E121', 'E126'}
        }
      }
    }
  }
}

