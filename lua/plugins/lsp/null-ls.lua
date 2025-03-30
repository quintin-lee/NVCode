return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require('null-ls')
        local formatting = null_ls.builtins.formatting

        null_ls.setup({
            sources = {
                formatting.prettier,
                formatting.stylua,
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
