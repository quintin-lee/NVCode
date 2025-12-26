return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp", -- Recommended for chat completion
		"nvim-telescope/telescope.nvim", -- For the action palette [14]
		"stevearc/dressing.nvim", -- For improved UI selects [15]
		"MeanderingProgrammer/render-markdown.nvim", -- For visual markdown
	},

	config = function()
		require("codecompanion").setup({
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
						llm = "  Qwen", -- Nerd Font icon for AI
						user = "  Me", -- Nerd Font icon for user
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
					provider = "telescope", -- Enhanced selection interface [14]
					opts = {
						width = 40,
						height = 10,
					},
				},
				chat = {
					window = {
						layout = "vertical", -- Vertical split for better context
						width = 0.3, -- 40% of screen width
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
					show_settings = false, -- Hide adapter settings for a cleaner look
				},
				diff = {
					enabled = true,
					provider = "mini_diff", -- Best-in-class diff highlighting [11]
				},
			},
			opts = {
				log_level = "ERROR", -- Reduce noise in logs [2, 16]
			},
		})

		-- Command abbreviations for speed
		vim.cmd([[cab cc CodeCompanion]])
		vim.cmd([[cab ccc CodeCompanionChat]])
	end,
}
