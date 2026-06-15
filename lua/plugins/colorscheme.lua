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
