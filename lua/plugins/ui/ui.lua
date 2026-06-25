return {
  {
    "folke/snacks.nvim",
    opts = {
      -- ============ 已启用模块 ============

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

      bigfile = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      gitbrowse = { enabled = false },
      lazygit = { enabled = false },
      notifier = { enabled = false }, -- 由 noice.nvim 接管通知
      profiler = { enabled = false },
      quickfile = { enabled = false },
      scratch = { enabled = false },
      words = { enabled = false },
      zen = { enabled = false },
    },
  },
}
