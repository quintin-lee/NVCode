return {
	"quintin-lee/header.nvim",
	config = function()
		require("header").setup({
			template_dir = vim.fn.stdpath("config") .. "/lua/plugins/header/templates/", -- Custom template directory
			templates = {
				["*.sh"] = "bash.txt",
				["*.c"] = "c.txt",
				["*.cpp"] = "cpp.txt",
				["*.py"] = "python.txt",
				["*.js"] = "javascript.txt",
				["*.ts"] = "typescript.txt",
				["*.java"] = "java.txt",
				["*.go"] = "go.txt",
				["*.rs"] = "rust.txt",
				["*.php"] = "php.txt",
				["*.rb"] = "ruby.txt",
				["*.swift"] = "swift.txt",
				["*.lua"] = "lua.txt",
				["*.R"] = "r.txt",
			},
		})
	end,
}

