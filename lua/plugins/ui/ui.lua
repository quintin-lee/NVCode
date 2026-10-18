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
        -- 首页分区：新增最近文件列表（1-9 快捷打开；无历史时自动隐藏）
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", limit = 5, indent = 2, padding = 2 },
          { section = "startup" },
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
      -- 注：lazygit/gitbrowse/scratch/zen/dim/profiler 不检查 enabled 配置（禁不掉），无需列出

      explorer = { enabled = false },
      notifier = { enabled = false }, -- 由 noice.nvim 接管通知
      quickfile = { enabled = false },
    },
  },
}
