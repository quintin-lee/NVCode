  require'lspconfig'.gopls.setup {
    on_attach = function(client)
      -- [[ other on_attach code ]]
      require 'illuminate'.on_attach(client)
    end,
  }

  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
