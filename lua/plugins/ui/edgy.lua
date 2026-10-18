--[edgy] IDE 风格边缘面板
-- neo-tree/dap-ui 左边缘 / outline 右边缘 / trouble/dap-ui 底部，替代传统侧栏布局

return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      { ft = "neo-tree", title = "Explorer" },
      -- dap-ui：调试面板停靠到边缘，不再自由 split/抖动
      { ft = "dapui_scopes", title = "Scopes" },
      { ft = "dapui_breakpoints", title = "Breakpoints" },
      { ft = "dapui_stacks", title = "Call Stack" },
      { ft = "dapui_watches", title = "Watches" },
    },
    right = {
      { ft = "outline", title = "Outline" },
    },
    bottom = {
      { ft = "trouble", title = "Trouble" },
      { ft = "dap-repl", title = "DAP REPL" },
      { ft = "dapui_console", title = "Console" },
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
