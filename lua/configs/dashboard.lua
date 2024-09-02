local config_home = vim.fn.stdpath("config")

local default_header = {
    '',
    '',
    '███╗   ██╗██╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗',
    '████╗  ██║██║   ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝',
    '██╔██╗ ██║██║   ██║██║     ██║   ██║██║  ██║█████╗  ',
    '██║╚██╗██║╚██╗ ██╔╝██║     ██║   ██║██║  ██║██╔══╝  ',
    '██║ ╚████║ ╚████╔╝ ╚██████╗╚██████╔╝██████╔╝███████╗',
    '╚═╝  ╚═══╝  ╚═══╝   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝',
    '                                                    ',
    '',
    '',
}

local db = require('dashboard')
db.setup ({
    theme = 'doom',
    config = {
        header = default_header, --your header
        packages = { enable = true }, -- show how many plugins neovim loaded
        center = {
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Open workspace',
                desc_hi = 'String',
                keymap = 'SPC w o',
                key = 'w',
                key_hi = 'Number',
                action = 'lua require("workspaces").open()'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'New file',
                desc_hi = 'String',
                keymap = 'SPC f n',
                key = 'n',
                key_hi = 'Number',
                action = 'DashboardNewFile'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Recently opened files',
                desc_hi = 'String',
                --action =  'DashboardFindHistory',
                action = 'Telescope frecency',
                keymap = 'SPC f r',
                key = 'r',
                key_hi = 'Number',
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Find  File',
                desc_hi = 'String',
                action = 'Telescope find_files find_command=rg,--hidden,--files',
                key_hi = 'Number',
                key = 'f',
                keymap = 'SPC f f'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'File Browser',
                desc_hi = 'String',
                action = 'Telescope file_browser',
                key_hi = 'Number',
                key = 'b',
                keymap = 'SPC f w'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Find  word',
                desc_hi = 'String',
                action = 'Telescope live_grep',
                key_hi = 'Number',
                key = 'g',
                keymap = 'SPC f g'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Open neovim configuration                                 ',
                desc_hi = 'String',
                action = 'e ' .. config_home .. '/init.lua',
                key_hi = 'Number',
                key = 'd',
                keymap = 'SPC f d'
            },
            {
                icon = '  ',
                icon_hi = 'Title',
                desc = 'Quit',
                desc_hi = 'String',
                action = 'q',
                key_hi = 'Number',
                key = 'SPC q',
                keymap = 'SPC q  '
            },
        },
        --footer = footer_lines, --your footer
    }
})
