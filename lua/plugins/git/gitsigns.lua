return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			numhl = false,
			linehl = false,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true, -- Disabled to improve performance
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000, -- Increased delay to reduce frequency
				ignore_whitespace = false,
			},
			sign_priority = 6,
			update_debounce = 200, -- Increased debounce to reduce updates
			status_formatter = nil, -- Use default
			max_file_length = 40000,
			preview_config = {
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
		vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GitGutterAdd" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GitGutterChange" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "GitGutterDelete" })
	end,
}
