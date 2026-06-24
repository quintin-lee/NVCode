-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 基础选项设置
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- 覆盖 LazyVim 默认缩进（2 → 4）
opt.shiftwidth = 4
opt.tabstop = 4

-- 高亮当前列（LazyVim 未默认开启）
opt.cursorcolumn = true

-- 启用标题栏（用于窗口管理器识别 neovim 实例）
opt.title = true
