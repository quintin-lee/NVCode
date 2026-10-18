return {
  {
    "folke/snacks.nvim",
    opts = {
      -- ============ 已启用模块 ============

      -- 大文件保护：超大文件自动禁用 LSP/treesitter 等重功能，防止卡顿
      bigfile = { enabled = true },

      -- ]] / [[ 引用跳转与 <a-n>/<a-p> 依赖此模块（LazyVim 默认启用）
      words = { enabled = true },

      dashboard = {
        preset = {
          header = [[
  ███╗   ██╗██╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗
  ████╗  ██║██║   ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝
  ██╔██╗ ██║██║   ██║██║     ██║   ██║██║  ██║█████╗
  ██║╚██╗██║╚██╗ ██╔╝██║     ██║   ██║██║  ██║██╔══╝
  ██║ ╚████║ ╚████╔╝ ╚██████╗╚██████╔╝██████╔╝███████╗
  ╚═╝  ╚═══╝  ╚═══╝   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
          ]],
        },
      },

      indent = {
        enabled = true,
        indent = {
          only_scope = false,
          char = "│",
        },
        scope = {
          enabled = true,
          char = "│",
        },
        chunk = {
          enabled = true,
        },
      },

      -- ============ 禁用未使用的模块（减少初始化开销） ============

      dim = { enabled = false },
      explorer = { enabled = false },
      gitbrowse = { enabled = false },
      lazygit = { enabled = false },
      notifier = { enabled = false }, -- 由 noice.nvim 接管通知
      profiler = { enabled = false },
      quickfile = { enabled = false },
      scratch = { enabled = false },
      zen = { enabled = false },
    },
  },
}
