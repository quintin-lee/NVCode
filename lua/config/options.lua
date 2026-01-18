-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 基础选项设置
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.relativenumber = true -- 相对行号 [2]
opt.shiftwidth = 4 -- 缩进空格数
opt.tabstop = 4
opt.expandtab = true
opt.clipboard = "unnamedplus" -- 共享系统剪贴板
opt.cursorline = true -- 高亮当前行
