require('themify').setup({
  -- Your list of colorschemes.

  'folke/tokyonight.nvim',
  'sho-87/kanagawa-paper.nvim',
  {
    'comfysage/evergarden',

    branch = 'mega'
  },
  {
      'navarasu/onedark.nvim',
      -- config = function()
      --     require('configs.theme')
      -- end,
  },

  -- Built-in colorschemes are also supported.
  -- (Also works with any colorschemes that are installed via other plugin manager, just make sure the colorscheme is loaded before Themify is loaded.)
  'default'
})
