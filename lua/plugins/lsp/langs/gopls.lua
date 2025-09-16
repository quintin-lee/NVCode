local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
    cmd = { 'gopls' },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },

    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    single_file_support = true,
})
