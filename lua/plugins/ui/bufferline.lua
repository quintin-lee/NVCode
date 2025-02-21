return {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require('bufferline').setup {
            options = {
                diagnostics = "nvim_lsp",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left"
                    },
                    {
                        filetype = "Outline",
                        text = "Outline",
                        highlight = "Directory",
                        text_align = 'left'
                    }
                },
                separator_style = "thin",
                numbers = function(opts)
                    return string.format('%s.%s', opts.id, opts.lower(opts.ordinal))
                end,
            }
        }
    end,
}
