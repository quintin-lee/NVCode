require'git-blame-virt'.setup {
	allow_foreign_repos = true,
	display = {
		commit_hash = true, -- Enable/Disable latest commit hash
		commit_summary = true, -- Enable/Disable latest commit summary
		commit_committers = true, -- Enable/Disable committers list
		max_committer = 3, -- Limit Number of committers display in list
		commit_time = true, -- Enable/Disable relative commit time
		hi = 'Comment', -- Change Highlight group of default highlight function
	},
	ft = {
		-- Enable/Disable plugin per filetype
		lua = true,
		java = false,
		javascript = false,
		latex = false,
		python = true,
		rust = false,
		cpp = true
	}
}
