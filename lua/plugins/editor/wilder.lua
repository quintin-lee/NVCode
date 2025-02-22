return {
    'gelguy/wilder.nvim',
    event = "CmdlineEnter",
    dependencies = {{ 'romgrk/fzy-lua-native' }},
    config = function()
        local wilder = require('wilder')
        vim.api.nvim_command("silent! UpdateRemotePlugins")
        wilder.setup({
            modes = {':', '/', '?'},
        })
        -- Disable Python remote plugin
        wilder.set_option('use_python_remote_plugin', 0)

        wilder.set_option('pipeline', {
            wilder.branch(
            wilder.cmdline_pipeline({
                fuzzy = 1,
                fuzzy_filter = wilder.lua_fzy_filter(),
            }),
            wilder.vim_search_pipeline()
            )
        })

        local highlighters = {
            wilder.pcre2_highlighter(),
            wilder.lua_fzy_highlighter(),
        }

        local popupmenu_renderer = wilder.popupmenu_renderer(
            wilder.popupmenu_palette_theme({
                highlighter = highlighters,
                -- 'single', 'double', 'rounded' or 'solid'
                -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
                border = 'rounded',
                max_height = '50%',      -- max height of the palette
                min_height = 0,          -- set to the same as 'max_height' for a fixed height window
                prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
                reverse = 0,             -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
                left = {
                    ' ',
                    wilder.popupmenu_devicons(),
                    wilder.popupmenu_buffer_flags({
                        flags = ' a + ',
                        icons = {['+'] = '', a = '', h = ''},
                    }),
                },
                right = {
                    ' ',
                    wilder.popupmenu_scrollbar(),
                },
            })
        )

        wilder.set_option('renderer', wilder.renderer_mux({
            [':'] = popupmenu_renderer,
            ['/'] = popupmenu_renderer,
        }))
    end,
}
