return {
  {
    "tanvirtin/vgit.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {
      -- 可以在这里配置 vgit 选项，默认启用全部现代化视觉追踪
    },
    config = function(_, opts)
      require("vgit").setup(opts)
    end,
  },
}
