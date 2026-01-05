return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local function open_nvim_tree(data)
			-- buffer is a real file on the disk
			local real_file = vim.fn.filereadable(data.file) == 1

			-- buffer is a [No Name]
			local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

			if not real_file and not no_name then
				return
			end

			-- open the tree, find the file but don't focus it
			require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
		end

		vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
			pattern = "NvimTree_*",
			callback = function()
				local layout = vim.api.nvim_call_function("winlayout", {})
				if
					layout[1] == "leaf"
					and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
					and layout[3] == nil
				then
					vim.cmd("confirm quit")
				end
			end,
		})
	end,
	config = function()
		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" }) -- 隐藏 \~ 符号区域背景
		vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" }) -- 垂直分割线背景透明
		require("nvim-tree").setup({
			update_focused_file = {
				enable = true, -- 启用实时定位
				update_root = false, -- 如果当前文件不在当前根目录下，自动切换根目录
				ignore_list = {}, -- 忽略定位的文件类型
			},
		})
	end,
}
