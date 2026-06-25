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
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=true",
            "--fallback-style=llvm",
          },
        },
      },
    },
  },
}
