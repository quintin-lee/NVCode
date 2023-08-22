require('bufferline').setup {
    options = {
        -- 使用 nvim 内置lsp
        diagnostics = "nvim_lsp",
        -- 左侧让出 nvim-tree 的位置
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
        numbers = function(opts)
            return string.format('%s.%s', opts.id, opts.lower(opts.ordinal))
        end,
    }
}

-- lualine config
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto', -- based on current vim colorscheme
        -- not a big fan of fancy triangle separators
        --component_separators = { left = '', right = '' },
        --section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        -- left
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', 'navic' },
        -- right
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'tabnine'},
        lualine_z = { 'progress', 'location' }
    },
    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}
