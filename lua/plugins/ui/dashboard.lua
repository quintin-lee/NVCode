return {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {{'nvim-tree/nvim-web-devicons'}},
    config = function()
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
        require('dashboard').setup({
            theme = 'doom',
            config = {
                header = default_header,
                center = {
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Open workspace',
                        desc_hl = 'String',
                        keymap = 'SPC w o',
                        key = 'w',
                        key_hl = 'Number',
                        action = 'lua require("workspaces").open()'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'New file',
                        desc_hl = 'String',
                        keymap = 'SPC f n',
                        key = 'n',
                        key_hl = 'Number',
                        action = 'DashboardNewFile'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Recently opened files',
                        desc_hl = 'String',
                        --action =  'DashboardFindHistory',
                        action = 'Telescope frecency',
                        keymap = 'SPC f r',
                        key = 'r',
                        key_hl = 'Number',
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Find  File',
                        desc_hl = 'String',
                        action = 'Telescope find_files find_command=rg,--hidden,--files',
                        key_hl = 'Number',
                        key = 'f',
                        keymap = 'SPC f f'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'File Browser',
                        desc_hl = 'String',
                        action = 'Telescope file_browser',
                        key_hl = 'Number',
                        key = 'b',
                        keymap = 'SPC f w'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Find  word',
                        desc_hl = 'String',
                        action = 'Telescope live_grep',
                        key_hl = 'Number',
                        key = 'g',
                        keymap = 'SPC f g'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Open neovim configuration                                 ',
                        desc_hl = 'String',
                        action = 'e ' .. config_home .. '/init.lua',
                        key_hl = 'Number',
                        key = 'd',
                        keymap = 'SPC f d'
                    },
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'Quit',
                        desc_hl = 'String',
                        action = 'q',
                        key_hl = 'Number',
                        key = 'SPC q',
                        keymap = 'SPC q  '
                    },
                },
            }
        })

        -- 在打开 dashboard 时关闭 NvimTree
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "dashboard",
            callback = function()
                require('nvim-tree.api').tree.close()
            end,
        })
    end,
}
