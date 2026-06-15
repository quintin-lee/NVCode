-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 全局配置诊断显示规则，避免在每次 LSP 挂载时重复执行
vim.diagnostic.config({
  -- 1. 过滤行尾文字
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  -- 2. 过滤侧边栏图标
  signs = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  -- 3. 过滤代码下划线（避免警告波浪线造成视觉干扰）
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
})
