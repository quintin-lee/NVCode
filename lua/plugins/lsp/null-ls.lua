return {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require('null-ls')
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        null_ls.setup({
            sources = {
                formatting.prettier,
                formatting.stylua,
                diagnostics.eslint,
                diagnostics.flake8,
            },
            -- on_attach = function(client)
            --     if client.server_capabilities.documentFormattingProvider then
            --         vim.cmd([[
            --             augroup LspFormatting
            --                 autocmd! * <buffer>
            --                 autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            --             augroup END
            --         ]])
            --     end
            -- end,
        })
    end,
}
