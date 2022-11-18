local status, actions = pcall(require, "telescope.actions")
if (not status) then
  return
end

local commit_type = require("configs.emojis")

--local actions = require('telescope.actions')
-- Global remapping
------------------------------
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
        hijack_netrw = true,
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

                local scope_msg = string.format("%s(%s):", entry.key, scope)

                vim.ui.input({ prompt = "Enter commit msg: " .. entry.value .. " "}, function(msg)
                    if not msg then
                        return
                    end

                    local git_tool = ":!git"
                    if vim.g.loaded_fugitive then
                        git_tool = ":G"
                    end

                    vim.cmd(string.format('%s commit -m "%s %s %s"', git_tool, entry.value, scope_msg, msg))
                end)
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

