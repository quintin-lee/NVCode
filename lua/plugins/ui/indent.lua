return {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function()
        require('ibl').setup({
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = true },
            exclude = {
                filetypes = {
                    "help",
                    "dashboard",
                    "packer",
                    "NvimTree",
                    "Trouble",
                    "TelescopePrompt",
                    "Float",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                    "quickfix",
                    "prompt",
                },
            },
        })
    end,
}
