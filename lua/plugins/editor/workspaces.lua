return {
    'natecraddock/workspaces.nvim',
    event = "VeryLazy",
    dependencies = {{
        'natecraddock/sessions.nvim',
    }},
    config = function()
        local ws = require("workspaces")
        local sessions = require("sessions")

        sessions.setup({
            -- autocmd events which trigger a session save
            --
            -- the default is to only save session files before exiting nvim.
            -- you may wish to also save more frequently by adding "BufEnter" or any
            -- other autocmd event
            events = { "VimLeavePre" },
            session_filepath = ".nvim/session",
        })

        ws.setup({
            hooks = {
                add = function()
                    sessions.save(nil, {})
                end,
                open_pre = {
                    "SessionsStop",
                    "silent %bdelete!",
                },
                open = function()
                    sessions.load(nil, { silent = true })
                    require('nvim-tree.api').tree.open()
                    -- 聚焦到代码窗口
                    vim.cmd("wincmd p")
                end,
            }
        })
    end,
}
