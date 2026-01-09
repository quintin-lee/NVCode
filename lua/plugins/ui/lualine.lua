return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"SmiteshP/nvim-navic",
		"AndreM222/copilot-lualine",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "onedark",
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					-- Only show AI indicators that are active
					function()
						if package.loaded["copilot"] then
							return "copilot"
						elseif package.loaded["tabnine"] then
							return "tabnine"
						else
							return "" -- Return empty if no AI tool is active
						end
					end,
					"encoding",
					"fileformat",
					"filetype"
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
