return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  -- LazyVim 推荐通过 keys 映射快捷键，或者在 config 中设置
  keys = {
    -- 基础对话与动作
    { "<leader>Cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
    { "<leader>Ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },

    -- 代码内联操作
    { "<leader>Ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection to Chat" },

    -- 常用辅助功能
    { "<leader>Ce", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "Explain Code" },
    { "<leader>Cf", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "Fix Code" },
    { "<leader>Cl", "<cmd>CodeCompanion /lsp<cr>", mode = "n", desc = "Explain LSP Diagnostics" },
    { "<leader>Cm", "<cmd>CodeCompanion /commit<cr>", mode = "n", desc = "Generate Commit Message" },
  },
  opts = {
    adapters = {
      acp = {
        qwen_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            commands = {
              default = { "qwen", "--experimental-acp" },
            },
            defaults = {
              auth_method = "qwen-oauth",
              oauth_credentials_path = vim.fs.abspath("~/.qwen/oauth_creds.json"),
              timeout = 20000,
            },
            handlers = {
              auth = function(self)
                local oauth_path = self.defaults.oauth_credentials_path
                return (oauth_path and vim.fn.filereadable(oauth_path)) == 1
              end,
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "qwen_cli",
        roles = {
          llm = "  Qwen",
          user = "  Me",
        },
        keymaps = {
          send = {
            modes = { n = "<CR>", i = "<C-s>" },
            index = 1,
            callback = "keymaps.send",
            description = "Send message",
          },
          stop = {
            modes = { n = "<C-c>" },
            index = 2,
            callback = "keymaps.stop",
            description = "Stop generation",
          },
          clear = {
            modes = { n = "gc" },
            index = 3,
            callback = "keymaps.clear",
            description = "Clear chat",
          },
        },
      },
      inline = {
        adapter = "qwen_cli",
        keymaps = {
          accept = {
            modes = { n = "ga" },
            index = 1,
            callback = "keymaps.accept",
            description = "Accept change",
          },
          reject = {
            modes = { n = "gr" },
            index = 2,
            callback = "keymaps.reject",
            description = "Reject change",
          },
        },
      },
      cmd = { adapter = "qwen_cli" },
    },
    display = {
      action_palette = {
        provider = "telescope",
        opts = { width = 0.4, height = 0.5 },
      },
      chat = {
        window = {
          layout = "vertical",
          width = 0.3,
          border = "rounded",
          relative = "editor",
          opts = {
            breakindent = true,
            cursorline = true,
            linebreak = true,
            number = false,
            relativenumber = false,
            signcolumn = "no",
            wrap = true,
          },
        },
        intro_message = "Qwen AI Assistant Active. Use /buffer or /files to add context.",
        show_settings = false,
      },
      diff = {
        enabled = true,
        provider = "mini_diff",
      },
    },
    opts = {
      log_level = "ERROR",
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)

    -- 在 LazyVim 环境下设置命令缩写
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccc CodeCompanionChat]])
  end,
}
