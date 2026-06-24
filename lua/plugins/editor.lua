return {
  {
    "kylechui/nvim-surround",
    -- 使用 VeryLazy 确保不会延迟文件打开
    event = "VeryLazy",
    opts = {},
  },
  {
    "cbochs/grapple.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 在 tags 面板中显示图标
    },
    opts = {
      scope = "git", -- 按 Git 项目隔离 tag 列表
    },
    config = function(_, opts)
      require("grapple").setup(opts)

      -- 在 Telescope 中显示 grapple tags
      -- 由于已迁移到 snacks_picker，这里不需要 telescope 集成
    end,
    keys = {
      -- 标记/取消标记当前文件
      { "<leader>ga", "<cmd>Grapple toggle<cr>", desc = "Toggle tag" },

      -- 按索引跳转（1-5 快速跳转）
      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple 1" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple 2" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple 3" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple 4" },
      { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple 5" },

      -- 打开 tags 侧边栏
      { "<leader>gt", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags panel" },
    },
  },
}
