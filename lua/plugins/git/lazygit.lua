return {
    'kdheepak/lazygit.nvim',
    cmd = "LazyGit",
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })
    end,
}
