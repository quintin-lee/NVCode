return {
    'numToStr/FTerm.nvim',
    config = function()
        require'FTerm'.setup({
            border = 'double',
            dimensions  = {
                height = 0.9,
                width = 0.9,
                x = 0.5,
                y = 0.5
            },
        })

        vim.api.nvim_set_keymap('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
    end,
}
