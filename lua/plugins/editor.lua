return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true, -- <--- 显式添加这一行，强制启用插件
    opts = {
      current_line_blame = true, -- 显式开启
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 100, -- 进一步缩短延迟用于测试
        ignore_whitespace = false,
      },
      -- 增加格式化配置，确保输出不为空
      current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
      update_debounce = 100,
    },
  },
}
