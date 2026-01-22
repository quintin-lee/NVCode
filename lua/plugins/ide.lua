return {
  -- 1. Sticky Headers (上下文保持)
  -- 在滚动长函数时，将函数名固定在顶部
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
      mode = "cursor",
      max_lines = 3, -- 最多显示3行上下文
    },
  },

  -- 2. Todo Comments (任务高亮)
  -- 高亮显示 TODO, FIXME, BUG, HACK, NOTE 等注释，并支持搜索
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTelescope", "TodoTrouble" },
    event = "LazyFile",
    opts = {},
    -- 快捷键配置
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todo" },
    },
  },
}
