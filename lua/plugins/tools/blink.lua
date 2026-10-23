--[blink] 补全引擎：blink.cmp
-- 默认跟随版本化 release（预编译二进制）；仅在 vim.g.lazyvim_blink_main = true 时从源码编译

return {
  {
    "saghen/blink.cmp",
    -- 仅跟随 main 分支时从源码编译；release 版本用预编译二进制
    -- 跟随 main 需要系统安装 rust 和 cargo（vim.g.lazyvim_blink_main = true 开启）
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts = {
      -- 也可以尝试强制使用特定的版本，通常版本匹配能解决二进制下载问题
      -- version = 'v0.5.1', 
    },
  },
}
