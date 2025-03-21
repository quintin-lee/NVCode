return {
    'terrortylor/nvim-comment',
    -- event = "VeryLazy",
    config = function()
        require('nvim_comment').setup({
            marker_padding = true,
            comment_empty = false,
            create_mappings = true,
            line_mapping = "gcc",
            operator_mapping = "gc",
            hook = nil
        })
    end,
}
