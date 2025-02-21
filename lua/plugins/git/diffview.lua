return {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('diffview').setup({
            diff_binaries = false,    -- Show diffs for binaries
            enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
            use_icons = true,         -- Requires nvim-web-devicons
            icons = {                 -- Only applies when use_icons is true.
                folder_closed = "",
                folder_open = "",
            },
            signs = {
                fold_closed = "",
                fold_open = "",
            },
            file_panel = {
                win_config = {
                    position = "left", -- One of 'left', 'right', 'top', 'bottom'
                    width = 35,        -- Only applies when position is 'left' or 'right'
                    height = 10,       -- Only applies when position is 'top' or 'bottom'
                },
            },
            file_history_panel = {
                win_config = {
                    position = "bottom",
                    width = 35,
                    height = 16,
                },
            },
            key_bindings = {
                disable_defaults = false, -- Disable the default key bindings
                view = {
                    ["<tab>"] = require('diffview.actions').select_next_entry,
                    ["<s-tab>"] = require('diffview.actions').select_prev_entry,
                    ["gf"] = require('diffview.actions').goto_file,
                    ["<C-w><C-f>"] = require('diffview.actions').goto_file_split,
                    ["<C-w>gf"] = require('diffview.actions').goto_file_tab,
                    ["<leader>e"] = require('diffview.actions').focus_files,
                    ["<leader>b"] = require('diffview.actions').toggle_files,
                },
                file_panel = {
                    ["j"] = require('diffview.actions').next_entry,
                    ["<down>"] = require('diffview.actions').next_entry,
                    ["k"] = require('diffview.actions').prev_entry,
                    ["<up>"] = require('diffview.actions').prev_entry,
                    ["<cr>"] = require('diffview.actions').select_entry,
                    ["o"] = require('diffview.actions').select_entry,
                    ["<2-LeftMouse>"] = require('diffview.actions').select_entry,
                    ["-"] = require('diffview.actions').toggle_stage_entry,
                    ["S"] = require('diffview.actions').stage_all,
                    ["U"] = require('diffview.actions').unstage_all,
                    ["X"] = require('diffview.actions').restore_entry,
                    ["R"] = require('diffview.actions').refresh_files,
                    ["<tab>"] = require('diffview.actions').select_next_entry,
                    ["<s-tab>"] = require('diffview.actions').select_prev_entry,
                    ["gf"] = require('diffview.actions').goto_file,
                    ["<C-w><C-f>"] = require('diffview.actions').goto_file_split,
                    ["<C-w>gf"] = require('diffview.actions').goto_file_tab,
                    ["i"] = require('diffview.actions').listing_style,
                    ["f"] = require('diffview.actions').toggle_flatten_dirs,
                    ["<leader>e"] = require('diffview.actions').focus_files,
                    ["<leader>b"] = require('diffview.actions').toggle_files,
                },
                file_history_panel = {
                    ["g!"] = require('diffview.actions').options,
                    ["<C-A-d>"] = require('diffview.actions').open_in_diffview,
                    ["y"] = require('diffview.actions').copy_hash,
                    ["zR"] = require('diffview.actions').open_all_folds,
                    ["zM"] = require('diffview.actions').close_all_folds,
                    ["j"] = require('diffview.actions').next_entry,
                    ["<down>"] = require('diffview.actions').next_entry,
                    ["k"] = require('diffview.actions').prev_entry,
                    ["<up>"] = require('diffview.actions').prev_entry,
                    ["<cr>"] = require('diffview.actions').select_entry,
                    ["o"] = require('diffview.actions').select_entry,
                    ["<2-LeftMouse>"] = require('diffview.actions').select_entry,
                    ["<tab>"] = require('diffview.actions').select_next_entry,
                    ["<s-tab>"] = require('diffview.actions').select_prev_entry,
                    ["gf"] = require('diffview.actions').goto_file,
                    ["<C-w><C-f>"] = require('diffview.actions').goto_file_split,
                    ["<C-w>gf"] = require('diffview.actions').goto_file_tab,
                    ["<leader>e"] = require('diffview.actions').focus_files,
                    ["<leader>b"] = require('diffview.actions').toggle_files,
                },
                option_panel = {
                    ["<tab>"] = require('diffview.actions').toggle_stage_entry,
                    ["q"] = require('diffview.actions').close,
                },
            },
        })
    end,
} 