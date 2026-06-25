--[edgy] IDE 风格边缘面板
-- neo-tree 左边缘 / outline 右边缘，替代传统侧栏布局

return {
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
      enabled = false,
    },
    exit_when_last = false,
  },
  keys = {
    { "<leader>te", "<cmd>EdgyToggle<cr>", desc = "Toggle Edgy" },
  },
}
