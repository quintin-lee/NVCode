return {
    'glepnir/lspsaga.nvim',
    event = "LspAttach",
    config = function()
        require('lspsaga').setup({
            ui = {
                border = 'rounded',
                winblend = 10,
                colors = {
                    normal_bg = '#1e222a',
                },
            },
            symbol_in_winbar = {
                enable = true,
                separator = '  ',
                hide_keyword = true,
                show_file = true,
                folder_level = 2,
                respect_root = false,
                color_mode = true,
            },
            lightbulb = {
                enable = true,
                sign = true,
                enable_in_insert = true,
                sign_priority = 20,
                virtual_text = true,
            },
            code_action = {
                num_shortcut = true,
                show_server_name = true,
                extend_gitsigns = true,
            },
            finder = {
                max_height = 0.5,
                min_width = 30,
                force_max_height = false,
                keys = {
                    jump_to = 'p',
                    expand_or_jump = 'o',
                    vsplit = 's',
                    split = 'i',
                    tabe = 't',
                    tabnew = 'r',
                    quit = {'q', '<ESC>'},
                    close_in_preview = '<ESC>'
                },
            },
        })
    end,
}
