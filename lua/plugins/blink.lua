--[blink] 补全引擎：blink.cmp
-- 如果预编译二进制下载失败，强制从源码编译（需 rust + cargo）

return {
  {
    "saghen/blink.cmp",
    -- 如果预编译二进制文件下载失败，强制从源码编译
    -- 这需要你的系统安装了 rust 和 cargo
    build = "cargo build --release",
    opts = {
      -- 也可以尝试强制使用特定的版本，通常版本匹配能解决二进制下载问题
      -- version = 'v0.5.1', 
    },
  },
}
