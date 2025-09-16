local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    single_file_support = true,
}
