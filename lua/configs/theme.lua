require('onedark').setup {
    style = 'darker',
    transparent = true,
    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'italic',
        keywords = 'bold',
        functions = 'italic,bold',
        strings = 'none',
        variables = 'none'
    },
    -- Lualine options --
    lualine = {
        transparent = true, -- lualine center bar transparency
    },
}

require('onedark').load()
