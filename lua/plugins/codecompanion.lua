return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat" },
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
    { "<leader>Ct", "<cmd>CodeCompanionToggleModel<cr>", mode = "n", desc = "Toggle AI Model (Gemini/Qwen)" },
  },
  opts = {
    adapters = {
      qwen_cli = function()
        return require("codecompanion.adapters").extend("gemini_cli", {
          commands = { default = { "qwen", "--experimental-acp" } },
          defaults = {
            auth_method = "qwen-oauth",
            oauth_credentials_path = vim.fs.abspath("~/.qwen/oauth_creds.json"),
            timeout = 20000,
          },
          handlers = {
            auth = function(self)
              return vim.fn.filereadable(self.defaults.oauth_credentials_path) == 1
            end,
          },
        })
      end,
      gemini_cli = function()
        return require("codecompanion.adapters").extend("gemini_cli", {
          commands = { default = { "gemini", "--experimental-acp" } },
          defaults = {
            auth_method = "gemini-oauth",
            oauth_credentials_path = vim.fs.abspath("~/.gemini/oauth_creds.json"),
            timeout = 20000,
          },
          handlers = {
            auth = function(self)
              return vim.fn.filereadable(self.defaults.oauth_credentials_path) == 1
            end,
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "gemini_cli",
        roles = {
          llm = "  Gemini",
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
        adapter = "gemini_cli",
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
      cmd = { adapter = "gemini_cli" },
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
        intro_message = "Gemini AI Assistant Active. Use /buffer or /files to add context.",
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

      -- 设置命令缩写
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])

      -- 简化的模型切换
      vim.api.nvim_create_user_command("CodeCompanionToggleModel", function()
        local config = require("codecompanion.config")
        local interface = config.config.interactions or config.config.strategies
        
        if not interface then return end
        
        local current_adapter = interface.chat.adapter
        local new_adapter = (current_adapter == "gemini_cli") and "qwen_cli" or "gemini_cli"
        
        -- 切换所有适配器
        for _, key in ipairs({ "chat", "inline", "cmd" }) do
          if interface[key] then interface[key].adapter = new_adapter end
        end
        
        -- 更新显示信息
        local model_names = { gemini_cli = "Gemini", qwen_cli = "Qwen" }
        interface.chat.roles.llm = "  " .. model_names[new_adapter]
        config.config.display.chat.intro_message = model_names[new_adapter] .. " AI Assistant Active. Use /buffer or /files to add context."
        
        vim.notify("CodeCompanion adapter switched to: " .. model_names[new_adapter], vim.log.levels.INFO)
      end, { desc = "Toggle CodeCompanion AI Model" })
    end,
}
