return {
    'RRethy/vim-illuminate',
    event = "VeryLazy",
    config = function()
        require('illuminate').configure({
            providers = {
                'lsp',
                'treesitter',
                'regex',
            },
            delay = 100,
            filetype_overrides = {},
            filetypes_denylist = {
                'dirvish',
                'fugitive',
                'NvimTree',
                'TelescopePrompt',
            },
            under_cursor = true,
            min_count_to_highlight = 2,
        })
    end,
}
