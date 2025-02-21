return {
    'ggandor/leap.nvim',
    event = "VeryLazy",
    config = function()
        require('leap').add_default_mappings()
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
