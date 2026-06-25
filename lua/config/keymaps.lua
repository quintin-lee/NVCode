-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 浮动终端快捷键（替换 FTerm）
-- <A-i> 浮动终端 / <A-\> 底部分割（LazyVim 默认）
map("n", "<A-i>", function()
  local LazyVim = require("lazyvim.util")
  Snacks.terminal.toggle(nil, {
    cwd = LazyVim.root.git(),
    win = {
      style = "float",
      border = "double",
      width = 0.9,
      height = 0.9,
      row = 0.05,
      col = 0.05,
    },
  })
end, { desc = "Float Terminal (root dir)" })

-- Gitmoji commit (基于 Snacks Picker)
map({ "n", "v" }, "<leader>gc", function()
  require("tools.git-commit").commit()
end, { desc = "Gitmoji commit" })
