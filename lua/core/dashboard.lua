local home = os.getenv('HOME')

local default_header = {
    '',
    '',
    '',
    '',
    '',
    ' ██████╗ ██╗   ██╗      ██╗██████╗ ███████╗',
    '██╔═══██╗██║   ██║      ██║██╔══██╗██╔════╝',
    '██║   ██║██║   ██║█████╗██║██║  ██║█████╗  ',
    '██║▄▄ ██║╚██╗ ██╔╝╚════╝██║██║  ██║██╔══╝  ',
    '╚██████╔╝ ╚████╔╝       ██║██████╔╝███████╗',
    ' ╚══▀▀═╝   ╚═══╝        ╚═╝╚═════╝ ╚══════╝',
    '                                           ',
    '                                           ',
    '                                           ',
    '                                           ',
    '',
}

local db = require('dashboard')
db.custom_header = default_header
--db.preview_command = 'cat | lolcat -F 0.3'
--db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
--db.preview_file_height = 12
--db.preview_file_width = 80
db.custom_center = {
    { icon = '  ',
        desc = 'Open workspace                          ',
        shortcut = 'SPC w o',
        action = 'lua require("workspaces").open()' },
    { icon = '  ',
        desc = 'New file                                ',
        shortcut = 'SPC f n',
        action = 'DashboardNewFile' },
    { icon = '  ',
        desc = 'Recently opened files                   ',
        --action =  'DashboardFindHistory',
        action = 'Telescope frecency',
        shortcut = 'SPC f r' },
    { icon = '  ',
        desc = 'Find  File                              ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = 'SPC f f' },
    { icon = '  ',
        desc = 'File Browser                            ',
        action = 'Telescope file_browser',
        shortcut = 'SPC f w' },
    { icon = '  ',
        desc = 'Find  word                              ',
        action = 'Telescope live_grep',
        shortcut = 'SPC f g' },
    { icon = '  ',
        desc = 'Open neovim configuration               ',
        action = 'e ' .. home .. '/.config/nvim/init.lua',
        shortcut = 'SPC f d' },
    { icon = '  ',
        desc = 'Quit                                    ',
        action = 'q',
        shortcut = 'SPC q  ' },
}
