return {
    'voldikss/vim-translator',
    config = function()
        vim.g.translator_default_engines = {'bing', 'youdao'}
        vim.api.nvim_set_keymap('n', '<leader>tt', '<Plug>Translate', {})
        vim.api.nvim_set_keymap('v', '<leader>tt', '<Plug>TranslateV', {})
    end,
}
