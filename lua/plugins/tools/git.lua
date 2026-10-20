--[git] Git 工具集成
-- gitsigns（行内 blame + hunk 操作） / vgit.nvim（可视化 diff）

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    enabled = true,
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 100,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
      update_debounce = 100,
    },
  },
  {
    "tanvirtin/vgit.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("vgit").setup(opts)
    end,
  },
}
