local lspconfig = require('lspconfig')

lspconfig.pylsp.setup {
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
    },
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    single_file_support = true,
}

