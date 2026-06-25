-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.diagnostic.config({
  -- 行尾文字：显示 3 级，前缀图标，超出截断
  virtual_text = {
    -- 按严重程度分级控制
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
    format = function(diagnostic)
      local icon = vim.diagnostic.severity[diagnostic.severity]
      -- 截断太长消息
      local msg = diagnostic.message:len() > 80 and diagnostic.message:sub(1, 77) .. "..." or diagnostic.message
      return string.format("%s %s", icon, msg)
    end,
  },

  -- 侧边栏图标：ERROR + WARN 显示
  signs = {
    severity = { min = vim.diagnostic.severity.WARN },
  },

  -- 代码下划线：仅 ERROR 避免视觉干扰
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },

  -- 浮动窗口快捷键更新时显示
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true, -- 显示 LSP 服务器名称
    header = "",
    prefix = "",
    format = function(diagnostic)
      return string.format(
        "%s %s: %s",
        vim.diagnostic.severity[diagnostic.severity],
        diagnostic.source or "",
        diagnostic.message
      )
    end,
  },

  -- 在输入时更新诊断（默认 200ms 已够用）
  update_in_insert = true,
  severity_sort = true, -- 按严重程度排序
})

-- 快捷键：LazyVim 默认已提供：
--   ]d/[d 诊断导航  ]e/[e 错误导航  ]w/[w 警告导航
--   <leader>cd      行内诊断浮动窗口
--   <leader>xx      Trouble 诊断面板
--   <leader>xX      当前 Buffer 诊断面板
--   <leader>ud      切换诊断显示
--   <leader>sd      Snacks picker 全局诊断
