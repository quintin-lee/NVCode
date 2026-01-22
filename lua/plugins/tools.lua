return {
  -- 浮动终端
  {
    "numToStr/FTerm.nvim",
    keys = {
      { "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>', mode = { "n", "t" }, desc = "Toggle Terminal" },
    },
    opts = { border = "double", dimensions = { height = 0.9, width = 0.9 } },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "quintin-lee/telescope-gitmoji.nvim", -- 将 gitmoji 设为依赖
    },

    -- gitmoji commit 快捷键配置
    keys = {
      { "<leader>gc", "<cmd>Telescope gitmoji<cr>", mode = { "n", "v" }, desc = "gitmoji commit" },
    },

    -- 所有的配置都必须注入到 telescope 的 opts 中
    opts = function(_, opts)
      -- 确保 extensions 表存在
      opts.extensions = opts.extensions or {}

      -- 从外部模块导入 gitmoji 配置
      local gitmoji_config = require("tools.gitmoji_commit").get_gitmoji_config()
      opts.extensions.gitmoji = gitmoji_config
    end,
    -- 2. 关键：在 Telescope 加载后手动加载该扩展
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("gitmoji")
    end,
  },
}
