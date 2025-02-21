return {
    'stevearc/dressing.nvim',
    config = function()
        require('dressing').setup({
            input = {
                enabled = true,
                default_prompt = "Input:",
                prompt_align = "left",
                insert_only = true,
                border = "rounded",
                relative = "cursor",
                prefer_width = 40,
                width = nil,
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },
            },
            select = {
                enabled = true,
                backend = { "telescope", "fzf", "builtin" },
                trim_prompt = true,
                telescope = nil,
                fzf = {
                    window = {
                        width = 0.5,
                        height = 0.4,
                    },
                },
                builtin = {
                    border = "rounded",
                    relative = "editor",
                },
            },
        })
    end,
}
