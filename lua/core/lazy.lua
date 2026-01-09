local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require("core.basic")

-- Enable faster startup by optimizing the loader
vim.loader.enable()

-- Preload common modules to improve startup time
local preload_modules = {
	"plenary.nvim",
	"nvim-web-devicons",
	"nvim-treesitter",
	"lualine",
	"telescope",
	"nvim-lspconfig",
	"nvim-cmp",
	"cmp-nvim-lsp",
}
for _, module in ipairs(preload_modules) do
	pcall(require, module)
end

-- 加载所有插件
require("lazy").setup(require("plugins"), {
	-- Configure default options for lazy.nvim
	defaults = {
		lazy = false, -- Disable lazy loading by default to ensure plugins work as expected
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- Reset the package path to improve startup time
		rtp = {
			reset = true,
			paths = {}, -- Additional paths to include in the runtime path
		},
	},
})
