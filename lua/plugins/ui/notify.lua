return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	config = function()
		require("notify").setup({
			background_colour = "#000000",
			fps = 60,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = "",
			},
			level = 2,
			minimum_width = 50,
			render = "default",
			stages = "fade_in_slide_out",
			timeout = 5000,
			top_down = true,
		})
		local notify = require("notify")

		-- 重新定义模块行为
		local filter_wrapper = function(msg, level, opts)
			if msg:find("multiple different client offset_encodings") or msg:find("position_encoding") then
				return
			end
			return notify(msg, level, opts)
		end
		-- 核心：确保覆盖全局 notify
		vim.notify = filter_wrapper
		package.loaded["notify"] = filter_wrapper
	end,
}
