return {
    'ggandor/leap.nvim',
    event = "VeryLazy",
    config = function()
        require('leap')
        -- 单次跳转：s/S 向下/向上
        vim.keymap.set({'n','x','o'}, 's',  '<Plug>(leap-forward)')
        vim.keymap.set({'n','x','o'}, 'S',  '<Plug>(leap-backward)')
        -- 跨窗口：gs
        vim.keymap.set({'n','x','o'}, 'gs', '<Plug>(leap-cross-window)')
        -- 自定义颜色
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'LeapMatch', {
            fg = 'white',
            bold = true,
            nocombine = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
            fg = 'red',
            bold = true,
            nocombine = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
            fg = 'blue',
            bold = true,
            nocombine = true,
        })
    end,
}
