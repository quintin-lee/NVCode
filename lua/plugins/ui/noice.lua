return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			lsp = {
				progress = {
					enabled = false, -- Disable progress notifications to reduce visual clutter
					-- Use a custom formatter to reduce CPU usage
					format = "lsp_progress",
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- 输入参数时自动弹出
					},
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				-- 自定义补全窗口样式
				hover = {
					enabled = true,
					silent = false, -- 不要静默错误
					view = "hover", -- 悬浮窗口样式
				},
			},
			-- Optimize cmdline for performance
			cmdline = {
				enabled = true,
				view = "cmdline", -- 使用传统命令行（非浮动窗口）
				format = {
					-- Reduce the number of enabled formats for performance
					cmdline = { pattern = "^:", icon = ":", ft = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = "🔍", ft = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = "🔍", ft = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", ft = "sh" },
					lua = { pattern = "^:%s*lua%s+", icon = "🌙", ft = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "💡" },
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = false, -- Disable to improve performance
				inc_rename = false,
				lsp_doc_border = false, -- Disable border for performance
			},
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			popupmenu = {
				enabled = true,
				backend = "nui", -- Use nui backend for better performance
			},
			health = {
				checker = false,
			},
			-- Optimize views for performance
			views = {
				hover = {
					size = { width = 60, height = 15 }, -- Limit window size
					win_options = {
						winblend = 10, -- Add transparency to reduce visual impact
					},
				},
				cmdline_popup = {
					size = { width = 60, height = 12 },
					position = { row = -2 },
					win_options = {
						winblend = 10,
					},
				},
			},
		})
	end,
}
