--[colorscheme] 主题配置
-- kanagawa（默认） + onedark（备选）

return {
  -- add onedark
  { "navarasu/onedark.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to load onedark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
