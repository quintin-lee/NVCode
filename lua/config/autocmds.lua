-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      -- 1. 过滤行尾文字
      virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      -- 2. 过滤侧边栏图标
      signs = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      -- 3. 过滤代码下划线（通常大家觉得警告烦是因为有波浪线）
      underline = {
        severity = { min = vim.diagnostic.severity.ERROR },
      },
    })
  end,
})
