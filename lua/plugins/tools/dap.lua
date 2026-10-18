--[dap] 调试配置覆盖
-- nvim-dap-ui 的 controls 默认占用 repl 窗口 winbar（与 edgy 标题栏硬冲突）
-- 关闭后 repl 保留 edgy 标题栏；调试操作用现有键位（<leader>dc 等）
return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      controls = { enabled = false },
    },
  },
}
