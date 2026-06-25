return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
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
    { "<leader>Ct", "<cmd>CodeCompanionToggleModel<cr>", mode = "n", desc = "Toggle AI Model (OpenCode/Gemini/Qwen)" },
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
        adapter = "opencode",
        roles = {
          llm = "  OpenCode",
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
        adapter = "opencode",
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
      cmd = { adapter = "opencode" },
    },
    display = {
      action_palette = {
        provider = "default",
        opts = { width = 0.4, height = 0.5 },
      },
      chat = {
        window = {
          layout = "vertical",
          width = 72, -- 固定 72 列（>1 为绝对列数，<1 为相对比例）
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
        intro_message = "OpenCode AI Assistant Active. Use /buffer or /files to add context.",
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
    prompt_library = {
      ["Generate Commit Message"] = {
        strategy = "chat",
        description = "Generate a commit message from the current staged changes",
        opts = {
          index = 9,
          is_default = true,
          is_slash_cmd = true,
          short_name = "commit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "system",
            content = "You are an expert at writing concise and meaningful commit messages. Use English only.",
          },
          {
            role = "user",
            content = function()
              return "Generate a commit message for the following changes:\n\n```git\n"
                .. vim.fn.system("git diff --staged")
                .. "\n```"
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
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

      if not interface then
        return
      end

      local current_adapter = interface.chat.adapter
      local adapters_list = { "opencode", "gemini_cli", "qwen_cli" }
      local idx = 1
      for i, name in ipairs(adapters_list) do
        if name == current_adapter then
          idx = i % #adapters_list + 1
          break
        end
      end
      local new_adapter = adapters_list[idx]

      -- 切换所有适配器
      for _, key in ipairs({ "chat", "inline", "cmd" }) do
        if interface[key] then
          interface[key].adapter = new_adapter
        end
      end

      -- 更新显示信息
      local model_names = { opencode = "OpenCode", gemini_cli = "Gemini", qwen_cli = "Qwen" }
      interface.chat.roles.llm = "  " .. model_names[new_adapter]
      config.config.display.chat.intro_message = model_names[new_adapter]
        .. " AI Assistant Active. Use /buffer or /files to add context."

      vim.notify("CodeCompanion adapter switched to: " .. model_names[new_adapter], vim.log.levels.INFO)
    end, { desc = "Toggle CodeCompanion AI Model" })
  end,
}
