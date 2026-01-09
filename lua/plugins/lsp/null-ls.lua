return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- Keep null-ls active only for diagnostics and code actions if needed
                -- Remove all formatting sources to prevent conflicts with conform.nvim
            },
            on_attach = function(client, bufnr)
                -- Explicitly disable formatting capabilities for null-ls to prevent conflicts
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,
        })
    end,
}
