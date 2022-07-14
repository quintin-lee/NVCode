local ws = require("workspaces")
local sessions = require("sessions")

sessions.setup({
    autosave = true,
    events = { "WinEnter" },
    session_filepath = ".nvim/session",
})

ws.setup({
    hooks = {
        add = function()
            sessions.save(nil)
        end,
        open_pre = {
            "SessionsStop",
            "silent %bdelete!",
        },
        open = function()
            sessions.load(nil, { silent = true })
        end,
    }
})
