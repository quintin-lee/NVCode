--[colorscheme] 主题配置
-- kanagawa（默认） + onedark（备选）

return {
  -- onedark：备选主题（<leader>uC 中可切换）
  { "navarasu/onedark.nvim" },
  -- kanagawa：默认主题，背景透明
  { "rebelot/kanagawa.nvim", opts = { transparent = true } },

  -- Configure LazyVim to load kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
