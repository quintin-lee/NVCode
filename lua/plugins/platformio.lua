return {
  {
    "anurag3301/nvim-platformio.lua",
    dependencies = {
      { "akinsho/toggleterm.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    -- 移除 cmd 延迟加载，防止命令无法识别
    -- 且该插件的命令通常是首字母大写 Pio 而非全大写 PIO
    config = function()
      require("platformio").setup({
        hotkeys = {
          main_menu = "<leader>\\",
        },
      })
    end,
    keys = {
      { "<leader>pi", "<cmd>Pioinit<cr>", desc = "PlatformIO Init" },
      { "<leader>pr", "<cmd>Piorun<cr>", desc = "PlatformIO Run" },
      { "<leader>pu", "<cmd>Piorun upload<cr>", desc = "PlatformIO Upload" },
      { "<leader>pm", "<cmd>Piomon<cr>", desc = "PlatformIO Monitor" },
    },
  },
}
