return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'ray-x/lsp_signature.nvim',
        'tjdevries/nlua.nvim',
        'hrsh7th/nvim-cmp',
        {
            'salkin-mada/openscad.nvim',
            dependencies = { 'L3MON4D3/LuaSnip', build = "make install_jsregexp" },
        },
    },

    lazy = false,
    config = function()
        local lspconfig = require('lspconfig')
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        local lsp_servers = {
            'bashls',
            'lua_ls',
            'jdtls',
            'pylsp',
            'clangd',
            'cmake',
            'rust_analyzer',
        }

        require('mason-lspconfig').setup({
            ensure_installed = lsp_servers,
            automatic_installation = true,
        })

        for _, lsp in ipairs(lsp_servers) do
            lspconfig[lsp].setup {
                on_attach = function(client, bufnr)
                    require "lsp_signature".on_attach()
                end,
                capabilities = capabilities,
                single_file_support = true,
            }
        end
        require("plugins.lsp.langs")       -- 语言服务器
    end,
}
