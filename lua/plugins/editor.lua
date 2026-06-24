return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "cbochs/grapple.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      scope = "git",
    },
    keys = {
      { "<leader>ga", "<cmd>Grapple toggle<cr>", desc = "Tag file" },
      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple 1" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple 2" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple 3" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple 4" },
      { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple 5" },
      { "<leader>gt", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags panel" },
    },
  },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      tmux_show_only_in_active_window = false,
      integrations = {
        markdown = {
          enabled = true,
          filetypes = { "markdown", "vimwiki" },
          clear_in_insert_mode = false,
          only_render_image_at_cursor = false,
        },
      },
      max_width_window_percentage = 100,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      left = {
        { ft = "neo-tree", title = "Explorer" },
      },
      right = {
        { ft = "outline", title = "Outline" },
      },
      animate = {
        enabled = false, -- 禁用动画，避免与 Snacks 动画冲突
      },
      exit_when_last = false,
    },
    keys = {
      { "<leader>te", "<cmd>EdgyToggle<cr>", desc = "Toggle Edgy" },
    },
  },
}
