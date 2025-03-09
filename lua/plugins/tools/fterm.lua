return {
    'numToStr/FTerm.nvim',
    config = function()
        local fterm = require("FTerm")

        local btop = fterm:new({
            ft = 'fterm_btop',
            cmd = "btop"
        })

        -- Use this to toggle btop in a floating terminal
        vim.keymap.set('n', '<A-b>', function()
            btop:toggle()
        end)

        vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })
        vim.api.nvim_create_user_command('FTermBtop', function() btop:toggle() end, { bang = true })

        fterm.setup({
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
