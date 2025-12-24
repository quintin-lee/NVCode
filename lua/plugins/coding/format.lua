return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      -- 1. 原有语言
      go = { "goimports", "gofmt" },
      python = { "ruff_format", "ruff_organize_imports" },
      c = { "clang-format" },
      cpp = { "clang-format" },

      -- 2. 新增：CUDA (通常使用 clang-format)
      cuda = { "clang-format" },

      -- 3. 新增：Rust (官方推荐 rustfmt)
      rust = { "rustfmt" },

      -- 4. 新增：Lua (开发 Neovim 插件必备)
      lua = { "stylua" },

      -- 5. 新增：前端/通用 (Prettier 支持多种格式)
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 1000, -- 增加到 1s，因为 Rust 和 CUDA 编译有时较慢
      lsp_format = "fallback",
    },
    -- 针对不同语言的格式化器自定义配置
    formatters = {
      ["clang-format"] = {
        -- 如果 CUDA 文件没有被识别，可以强制指定风格
        prepend_args = { "--style=file" },
      },
    },
  },
}
