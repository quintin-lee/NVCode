return {
  -- 浮动终端
  {
    "numToStr/FTerm.nvim",
    opts = { border = "double", dimensions = { height = 0.9, width = 0.9 } },
  },
  -- 翻译插件
  {
    "voldikss/vim-translator",
    keys = {
      { "<leader>ts", "<Plug>TranslateW", desc = "Translate Window" },
      { "<leader>tr", "<Plug>TranslateR", desc = "Translate Replace" },
    },
  },
}
