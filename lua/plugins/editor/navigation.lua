--[navigation] 跨项目文件快速跳转
-- grapple.nvim：按 Git 项目隔离 tag 列表，支持编号直达

return {
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
}
