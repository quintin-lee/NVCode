return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-telescope/telescope-file-browser.nvim',
        {'nvim-telescope/telescope-frecency.nvim', dependencies = { 'tami5/sqlite.lua' } },
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-symbols.nvim',
        'quintin-lee/telescope-gitmoji.nvim',
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local status, actions = pcall(require, "telescope.actions")
        if (not status) then
            return
        end

        local commit_type = require("plugins.tools.emojis")
        require("telescope").setup {
            defaults = {
                mappings = {
                    n = {
                        ["q"] = actions.close,
                        ["l"] = actions.file_edit
                    }
                },
                file_ignore_patterns = {"./node_modules"}
            },
            pickers = {
                find_files = {
                    theme = "ivy",
                    prompt_prefix = '🔍 ',
                },
                oldfiles = {
                    theme = "ivy",
                    prompt_prefix = '🔍 ',
                },
                buffers = {
                    theme = "ivy",
                    prompt_prefix = '🔍 ',
                },
                live_grep = {
                    theme = "ivy",
                    prompt_prefix = '🔍 ',
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                file_browser = {
                    theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = false,
                    mappings = {
                        ["i"] = {
                            -- your custom insert mode mappings
                        },
                        ["n"] = {
                            -- your custom normal mode mappings
                        },
                    },
                },
                frecency = {
                    -- db_root = "home/my_username/path/to/db_root",
                    show_scores = false,
                    show_unindexed = true,
                    ignore_patterns = {"*.git/*", "*/tmp/*"},
                    disable_devicons = false,
                },
                gitmoji = {
                    commit_type = commit_type,
                    action = function(entry)
                        -- entry = {
                            --     display = "🎨 Improve structure / format of the code.",
                            --     index = 1,
                            --     ordinal = "Improve structure / format of the code.",
                            --     value = "🎨"
                            -- }


                            vim.ui.input({ prompt = "Enter scope msg: " .. entry.key .. " "}, function(scope)
                                if not scope then
                                    return
                                end

                                local scope_msg = string.format("%s(%s): ", entry.key, scope)

                                -- Open a floating, multi-line buffer for composing the commit message
                                local buf = vim.api.nvim_create_buf(false, true) -- listed = false, scratch = true

                                local width = math.max(50, math.floor(vim.o.columns * 0.7))
                                local height = math.max(8, math.floor(vim.o.lines * 0.5))
                                local row = math.floor((vim.o.lines - height) / 2)
                                local col = math.floor((vim.o.columns - width) / 2)

                                local win = vim.api.nvim_open_win(buf, true, {
                                    relative = 'editor',
                                    width = width,
                                    height = height,
                                    row = row,
                                    col = col,
                                    style = 'minimal',
                                    border = 'rounded',
                                })

                                vim.api.nvim_buf_set_option(buf, 'filetype', 'gitcommit')
                                vim.api.nvim_buf_set_option(buf, 'buftype', 'acwrite')
                                vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

                                -- Create a small, persistent hint window just below the commit floating window
                                local hint_buf, hint_win
                                do
                                    hint_buf = vim.api.nvim_create_buf(false, true) -- scratch
                                    local hint_text = "Press <C-s> to commit, <C-c> to cancel"
                                    vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, { hint_text })
                                    vim.api.nvim_buf_set_option(hint_buf, 'bufhidden', 'wipe')
                                    vim.api.nvim_buf_set_option(hint_buf, 'modifiable', false)

                                    -- Position hint relative to the commit floating window so it reliably appears
                                    -- right below it. Use relative='win' and target the commit win id.
                                    local ok, winid = pcall(function() return win end)
                                    if ok and vim.api.nvim_win_is_valid(winid) then
                                        -- place the hint immediately below the floating window (row = height)
                                        hint_win = vim.api.nvim_open_win(hint_buf, false, {
                                            relative = 'win',
                                            win = winid,
                                            width = width,
                                            height = 1,
                                            row = height,
                                            col = 0,
                                            style = 'minimal',
                                            border = 'none',
                                            focusable = false,
                                            zindex = 200,
                                        })
                                    else
                                        -- fallback to editor-relative placement
                                        local hint_row = row + height
                                        if hint_row + 1 > vim.o.lines then
                                            hint_row = math.max(0, row + height - 1)
                                        end
                                        hint_win = vim.api.nvim_open_win(hint_buf, false, {
                                            relative = 'editor',
                                            width = width,
                                            height = 1,
                                            row = hint_row,
                                            col = col,
                                            style = 'minimal',
                                            border = 'none',
                                            focusable = false,
                                            zindex = 200,
                                        })
                                    end

                                    -- make hint slightly transparent so it looks elegant
                                    pcall(vim.api.nvim_win_set_option, hint_win, 'winblend', 10)
                                end

                                -- Pre-fill buffer: first line is the conventional subject line
                                local subject = string.format('%s %s', entry.value, scope_msg)
                                vim.api.nvim_buf_set_lines(buf, 0, -1, false, { subject, '', '' })

                                -- Place cursor at the end of the first line
                                vim.api.nvim_win_set_cursor(win, {1, #subject})

                                local function cleanup()
                                    if vim.api.nvim_win_is_valid(win) then
                                        pcall(vim.api.nvim_win_close, win, true)
                                    end
                                    if vim.api.nvim_buf_is_valid(buf) then
                                        pcall(vim.api.nvim_buf_delete, buf, { force = true })
                                    end
                                    if hint_win and vim.api.nvim_win_is_valid(hint_win) then
                                        pcall(vim.api.nvim_win_close, hint_win, true)
                                    end
                                    if hint_buf and vim.api.nvim_buf_is_valid(hint_buf) then
                                        pcall(vim.api.nvim_buf_delete, hint_buf, { force = true })
                                    end
                                end

                                local function do_commit()
                                    if not vim.api.nvim_buf_is_valid(buf) then
                                        return
                                    end
                                    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                                    -- remove leading/trailing empty lines
                                    while #lines > 0 and lines[#lines] == '' do
                                        table.remove(lines)
                                    end
                                    while #lines > 0 and lines[1] == '' do
                                        table.remove(lines, 1)
                                    end

                                    if #lines == 0 then
                                        vim.notify('Empty commit message, aborting', vim.log.levels.WARN)
                                        cleanup()
                                        return
                                    end

                                    local tmp = vim.fn.tempname()
                                    -- writefile accepts list-of-lines
                                    vim.fn.writefile(lines, tmp)

                                    local git_tool = ':!git'
                                    if vim.g.loaded_fugitive then
                                        git_tool = ':G'
                                    end

                                    -- Use -F to read the commit message from the temp file
                                    local cmd = string.format('%s commit -F "%s"', git_tool, tmp)
                                    vim.cmd(cmd)

                                    -- try to remove temp file (ignore errors)
                                    pcall(vim.loop.fs_unlink, tmp)

                                    cleanup()
                                end

                                -- Buffer-local mappings: <C-s> to commit, <C-c> to cancel
                                vim.keymap.set('n', '<C-s>', do_commit, { buffer = buf, silent = true })
                                vim.keymap.set('i', '<C-s>', function()
                                    vim.cmd('stopinsert')
                                    do_commit()
                                end, { buffer = buf, silent = true })

                                vim.keymap.set({'n', 'i'}, '<C-c>', function()
                                    cleanup()
                                end, { buffer = buf, silent = true })

                            end)
                        end,
                    },
                }
            }

            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("file_browser")
            require"telescope".load_extension("frecency")
            require("telescope").load_extension("gitmoji")
    end,
}
