--[noice] 消息通知配置
-- 将通知消息显示在右上角

return {
  "folke/noice.nvim",
  opts = {
    -- 将 vim.notify 和 cmdline 消息都路由到 mini 视图
    notify = {
      view = "mini",
    },
    messages = {
      view = "mini",
      view_error = "mini",
      view_warn = "mini",
    },
    views = {
      mini = {
        position = {
          -- 数值：正数从顶部计算，负数从底部计算；字符串百分比相对窗口
          row = 1,      -- 从顶部第 1 行
          col = "100%", -- 右侧对齐
        },
        -- 从右上角向下排列
        reverse = true,
      },
    },
  },
}
