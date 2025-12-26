return {
	"petertriho/nvim-scrollbar",
	event = "VeryLazy",
	config = function()
		local scrollbar = require("scrollbar")
		local colors = {
			white = "#ABB2BF",
			darker_black = "#1b1d28",
			black = "#1e202e", --  sidebar and floating bg
			black2 = "#25273a",
			one_bg = "#282a3e",
			one_bg2 = "#333652",
			one_bg3 = "#3c3f62",
			grey = "#4b517d",
			grey_fg = "#5c638f",
			grey_fg2 = "#646b90",
			light_grey = "#6f79a0",
			red = "#d47d85",
			baby_pink = "#DE8C92",
			pink = "#ff758f",
			line = "#2A2D3B", --  base
			green = "#A3BE8C",
			vibrant_green = "#7EC7A2",
			blue = "#61AFEF",
			yellow = "#EBCB8B",
			sun = "#FAC863",
			purple = "#B48EAD",
			dark_purple = "#9D7D9C",
			teal = "#50C4BE",
			orange = "#fca2aa",
			cyan = "#7EC7A2",
			statusline_bg = "#222436",
			lightbg = "#2D3044",
			lightbg2 = "#25273C",
			pmenu_bg = "#ff758f",
			folder_bg = "#61AFEF",
		}

		scrollbar.setup({
			handle = {
				text = " ",
				blend = 0.25, -- Adjust transparency for better performance
				color = colors.grey_fg,
				highlight = "CursorColumn",
			},
			marks = {
				Search = { text = { "-", "=" }, priority = 0 },
				Error = { text = { "-", "=" }, priority = 1 },
				Warn = { text = { "-", "=" }, priority = 2 },
				Info = { text = { "-", "=" }, priority = 3 },
				Hint = { text = { "-", "=" }, priority = 4 },
				Misc = { text = { "-", "=" }, priority = 5 },
			},
			excluded_buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
			excluded_filetypes = {
				"cmp_docs",
				"cmp_menu",
				"dashboard",
				"help",
				"lspinfo",
				"nvcheatsheet",
				"packer",
				"TelescopePrompt",
				"TelescopeResults",
			},
			autocmd = {
				render = {
					"BufWinEnter",
					"TabNew",
					"TermEnter",
					"WinEnter",
					"CmdwinLeave",
					"TextChanged",
					"VimResized",
					"WinScrolled",
				},
			},
		})

		-- Modern scrollbar handling - newer versions of nvim-scrollbar auto-update
		-- No manual handling needed for scroll events
		vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "BufWinLeave", "FocusLost" }, {
			callback = function()
				require("scrollbar").clear()
			end,
		})
	end,
}
