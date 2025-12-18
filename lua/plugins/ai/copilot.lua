return {
    "zbirenbaum/copilot.lua",
    dependencies = {
        "copilotlsp-nvim/copilot-lsp",
        init = function()
            vim.g.copilot_nes_debounce = 500
        end,
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            nes = {
                enabled = true,
                keymap = {
                    accept_and_goto = "<leader>p",
                    accept = false,
                    dismiss = "<Esc>",
                },
            },
        })
    end,
}
