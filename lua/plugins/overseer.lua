return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerBuild", "OverseerToggle", "OverseerQuickAction" },
  keys = {
    -- 主面板开关
    { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle panel" },
    -- 运行任务
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run task" },
    -- 快速操作（根据文件类型智能推荐）
    { "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "Overseer: Quick action" },
    -- 重新运行上次的构建/测试
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: Build" },
    -- 关闭所有已完成的任务
    { "<leader>ox", "<cmd>OverseerClearCache<cr>", desc = "Overseer: Clear cache" },
  },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 10,
      max_height = 20,
      default_detail = 1,
    },
    -- 自动从 LSP 发现任务
    auto_detect = true,
    -- 任务完成后通知
    confirm = {
      on_quit = false,
      on_kill = true,
    },
    -- 组件默认配置
    dap = false, -- 不接管 DAP（你已有 nvim-dap 配置）
  },
}
