-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- FTerm 快捷键配置 (兼容 NVCode 习惯)
map("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle Terminal" })
map("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle Terminal" })

-- gitmoji commit 快捷键配置
map("n", "<leader>gc", "<cmd>Telescope gitmoji<cr>", { desc = "gitmoji commit" })
