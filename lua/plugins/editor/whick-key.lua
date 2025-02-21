return {
    'folke/which-key.nvim',
    config = function()
        local wk = require("which-key")

        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        --local rest = require('rest-nvim')
        local neogen = require('neogen')
        local workspaces = require('workspaces')
        local goto_preview = require('goto-preview')

        local config_home = vim.fn.stdpath("config")

        wk.setup({
            ---@type false | "classic" | "modern" | "helix"
            preset = "modern",
            ---@type wk.Win.opts
            win = {
            -- don't allow the popup to overlap with the cursor
            no_overlap = true,
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
            title = true,
            title_pos = "center",
            zindex = 1000,
            -- Additional vim.wo and vim.bo options
            bo = {},
            wo = {
                -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
            },
            },
            layout = {
                width = { min = 25, max = 50 }, -- min and max width of the columns
                spacing = 5, -- spacing between columns
            },
        })

        wk.add({
        { "<leader>a", group = "AI" },
        { "<leader>aa", group = "Avante" },
        { "<leader>aac", "<cmd>AvanteChat<cr>", desc= "chat" },
        { "<leader>aaa", "<cmd>AvanteAsk<cr>", desc= "ask" },
        { "<leader>b", group = "buffer" },
        { "<leader>bd", "<cmd>bd<cr>", desc = "delete" },
        { "<leader>bf", "<cmd>bf<cr>", desc = "first" },
        { "<leader>bl", "<cmd>bl<cr>", desc = "last" },
        { "<leader>bn", "<cmd>bn<cr>", desc = "next" },
        { "<leader>bp", "<cmd>bp<cr>", desc = "previous" },
        { "<leader>bs", "<cmd>BufferList<cr>", desc = "list" },
        { "<leader>d", group = "debug" },
        { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "breakpoint" },
        { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "continue" },
        { "<leader>dh", "<cmd>:lua require'dap.ui.widgets'.hover()<cr>", desc = "view value under the cursor" },
        { "<leader>di", "<cmd>:lua require'dap'.step_into()<cr>", desc = "step into" },
        { "<leader>dl", "<cmd>:lua require('dap').run_last()<CR>", desc = "run last" },
        { "<leader>dn", "<cmd>:lua require'dap'.step_over()<cr>", desc = "step over" },
        { "<leader>do", "<cmd>:lua require'dap'.step_out()<cr>", desc = "step out" },
        { "<leader>dq", "<cmd>:lua require('dap').disconnect()<CR>", desc = "disconnect" },
        { "<leader>dr", "<cmd>:lua require('dap').repl.open()<CR>", desc = "repl open" },
        { "<leader>dx", "<cmd>:lua require('dapui').close()<CR>", desc = "ui close" },
        { "<leader>f", group = "file" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
        { "<leader>fd", "<cmd>e "..config_home.."/init.lua<cr>", desc = "Open neovim configuration" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Words" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>fn", "<cmd>DashboardNewFile<cr>", desc = "New File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", remap = true },
        { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle FileTree" },
        { "<leader>fw", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
        { "<leader>g", group = "git" },
        { "<leader>gb", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "BUffer Commit" },
        { "<leader>gc", "<cmd>Telescope gitmoji<cr>", desc = "gitmoji commit" },
        { "<leader>gd", group = "Diff View" },
        { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
        { "<leader>gdq", "<cmd>DiffviewClose <cr>", desc = "Close Diffview" },
        { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "Update Diffview" },
        { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "Project Commit" },
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>gs", "<cmd>LazyGitConfig<cr>", desc = "LazyGitConfig" },
        { "<leader>h", group = "http" },
        { "<leader>hr", "<cmd>Rest run<cr>", desc = "Run request under the cursor" },
        { "<leader>ho", "<cmd>Rest open<cr>", desc = "Open result pane" },
        { "<leader>hl", "<cmd>Rest last<cr>", desc = "Run last request" },
        { "<leader>hc", "<cmd>Rest cookies<cr>", desc = "Edit cookies file" },
        { "<leader>he", group = "env" },
        { "<leader>hew", "<cmd>Rest env show<cr>", desc = "Show dotenv file registered to current .http file" },
        { "<leader>hes", "<cmd>Rest env select<cr>", desc = "Select & register .env file with vim.ui.select()" },
        { "<leader>l", group = "lsp" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>lc", group = "Comment" },
        { "<leader>lcc",function() neogen.generate({ type = 'class' }) end, desc = "class" },
        { "<leader>lcf", function() neogen.generate({ type = 'file' }) end, desc = "file" },
        { "<leader>lcr", function() neogen.generate({ type = 'func' })end , desc = "function" },
        { "<leader>lct", function() neogen.generate({ type = 'type' })end , desc = "type" },
        { "<leader>lg", group = "Goto" },
        { "<leader>lgD", vim.lsp.buf.declaration, desc = "declaration" },
        { "<leader>lgd", vim.lsp.buf.definition, desc = "definition" },
        { "<leader>lgi", vim.lsp.buf.implementation, desc = "implementation" },
        { "<leader>lgr", vim.lsp.buf.references, desc = "references" },
        { "<leader>lgs", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "switch source/header" },
        { "<leader>lgt", vim.lsp.buf.type_definition, desc = "type definition" },
        { "<leader>lh", vim.lsp.buf.signature_help, desc = "Signature Help" },
        { "<leader>lk", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>lf", vim.lsp.buf.formatting, desc = "Format" },
        { "<leader>lp", group = "Goto Preview" },
        { "<leader>lpd", goto_preview.goto_preview_definition, desc = "definition" },
        { "<leader>lpi", goto_preview.goto_preview_implementation, desc = "implementation" },
        { "<leader>lpq", goto_preview.close_all_win, desc = "close" },
        { "<leader>lpr", goto_preview.goto_preview_references, desc = "references" },
        { "<leader>lpt", goto_preview.goto_preview_type_definition, desc = "type definition" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>ls", "<cmd>Lspsaga outline<cr>", desc = "Open Outline" },
        { "<leader>lw", group = "Workspace Folder" },
        { "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "add" },
        { "<leader>lwl", vim.lsp.buf.remove_workspace_folder, desc = "list" },
        { "<leader>lwr", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "remove" },
        { "<leader>m", group = "translate" },
        { "<leader>mf", "<cmd>Translate ZH -output=floating<cr>", desc = "floating" },
        { "<leader>mi", "<cmd>Translate ZH -output=insert<cr>", desc = "insert" },
        { "<leader>mr", "<cmd>Translate ZH -output=replace<cr>", desc = "replace" },
        { "<leader>ms", "<cmd>Translate ZH -output=split<cr>", desc = "split" },
        { "<leader>p", group = "plug" },
        { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
        { "<leader>ph", "<cmd>Lazy help<cr>", desc = "Help" },
        { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
        { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
        { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
        { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
        { "<leader>q", "<cmd>qa<cr>", desc = "quit" },
        { "<leader>s", group = "Setting" },
        { "<leader>st", "<cmd>Themify<cr>", desc = "Colorscheme manager and switcher" },
        { "<leader>t", group = "floaterm" },
        { "<leader>to", '<cmd>lua require("FTerm").toggle()<cr>', desc = "open" },
        { "<leader>w", group = "Workspace" },
        { "<leader>wa", function() workspaces.add() end, desc = "add" },
        { "<leader>wl", function() workspaces.list() end, desc = "list" },
        { "<leader>wo", function() workspaces.open() end, desc = "open" },
        { "<leader>wr", function() workspaces.remove(workspaces.name()) end, desc = "remove current workspace" },
        { "<leader>ws", "<cmd>SessionsSave<cr>", desc = "save session" },
        })
    end,
}
