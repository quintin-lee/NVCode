--[lsp] LSP 配置覆盖
-- 仅包含 deviating from LazyVim 默认的服务器选项

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- 修复启动参数，确保 boolean 值正确传递
          cmd = {
            "clangd",
            "--background-index",
            -- 后台索引降优先级：大项目（postgres/memcached 等）编译期间不抢占 CPU
            "--background-index-priority=low",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=true",
            "--fallback-style=llvm",
            -- 允许 clangd 执行交叉编译器提取系统头文件（STM32/ARM/ESP 等嵌入式工具链）
            "--query-driver=**/arm-none-eabi-gcc*,**/arm-none-eabi-g++*,**/xtensa-*-elf-gcc*",
            -- 读取项目级 .clangd / config.yaml 配置
            "--enable-config",
            -- PCH 缓存放内存，以内存换速度
            "--pch-storage=memory",
          },
        },
      },
    },
  },
}
