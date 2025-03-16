local lspconfig = require('lspconfig')

lspconfig.jdtls.setup {
    cmd = {
        'jdtls',
        '--jvm-arg=-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar',
    },
    root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml"),
    settings = {
        java = {}
    },
    init_options = {
        bundles = {}
    },
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    single_file_support = true,
}

