local wk = require("which-key")

vim.g.mapleader = " "
vim.g.maplocalleader = " "


--local rest = require('rest-nvim')
local neogen = require('neogen')
local workspaces = require('workspaces')
local goto_preview = require('goto-preview')

local config_home = vim.fn.stdpath("config")

wk.setup({
    window = {
        border = "double", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,  -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000, -- positive value to position WhichKey above other floating windows.
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
})

wk.add({
  { "<leader>a", group = "AI" },
  { "<leader>ab", group = "Bito" },
  { "<leader>abc", group = "Check" },
  { "<leader>abcc", "<cmd>BitoAiCheck<cr>", desc = "Performs a check for potential issues in the code and suggests improvements" },
  { "<leader>abcp", "<cmd>BitoAiCheckPerformance<cr>", desc = "Analyzes the code for performance issues and suggests optimizations" },
  { "<leader>abcs", "<cmd>BitoAiCheckSecurity<cr>", desc = "Checks the code for security issues and provides recommendations" },
  { "<leader>abct", "<cmd>BitoAiCheckStyle<cr>", desc = "Checks the code for style issues and suggests style improvements" },
  { "<leader>abe", "<cmd>BitoAiExplain<cr>", desc = "Generates an explanation for the selected code" },
  { "<leader>abg", "<cmd>BitoAiGenerate<cr>", desc = "Generates code based on a given prompt" },
  { "<leader>abm", "<cmd>BitoAiGenerateComment<cr>", desc = "Generates comments for methods, explaining parameters and output" },
  { "<leader>abr", "<cmd>BitoAiReadable<cr>", desc = "Organizes the code to enhance readability and maintainability" },
  { "<leader>abu", "<cmd>BitoAiGenerateUnit<cr>", desc = "Generates unit test code for the selected code block" },
  { "<leader>b", group = "buffer" },
  { "<leader>bd", "<cmd>bd<cr>", desc = "delete" },
  { "<leader>bf", "<cmd>bf<cr>", desc = "first" },
  { "<leader>bl", "<cmd>bl<cr>", desc = "last" },
  { "<leader>bn", "<cmd>bn<cr>", desc = "next" },
  { "<leader>bp", "<cmd>bp<cr>", desc = "previous" },
  { "<leader>bs", "<cmd>ls<cr>", desc = "list" },
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
  { "<leader>fd", "<cmd>e /home/quintin/.local/nvcode/bin/..//config/nvcode/init.lua<cr>", desc = "Open neovim configuration" },
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
  { "<leader>ls", "<cmd>SymbolsOutline<cr>", desc = "Open SymbolsOutline" },
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
  { "<leader>t", group = "floaterm" },
  { "<leader>to", '<cmd>lua require("FTerm").toggle()<cr>', desc = "open" },
  { "<leader>w", group = "Workspace" },
  { "<leader>wa", function() workspaces.add() end, desc = "add" },
  { "<leader>wl", function() workspaces.list() end, desc = "list" },
  { "<leader>wo", function() workspaces.open() end, desc = "open" },
  { "<leader>wr", function() workspaces.remove(workspaces.name()) end, desc = "remove current workspace" },
  { "<leader>ws", "<cmd>SessionsSave<cr>", desc = "save session" },
})

-- wk.register({
--     a = {
--         name = "AI",
--         b = {
--             name = "Bito",
--             g = {
--                 "<cmd>BitoAiGenerate<cr>",
--                 "Generates code based on a given prompt"
--             },
--             u = {
--                 "<cmd>BitoAiGenerateUnit<cr>",
--                 "Generates unit test code for the selected code block"
--             },
--             m = {
--                 "<cmd>BitoAiGenerateComment<cr>",
--                 "Generates comments for methods, explaining parameters and output"
--             },
--             c = {
--                 name = "Check",
--                 c = {
--                     "<cmd>BitoAiCheck<cr>",
--                     "Performs a check for potential issues in the code and suggests improvements"
--                 },
--                 s = {
--                     "<cmd>BitoAiCheckSecurity<cr>",
--                     "Checks the code for security issues and provides recommendations"
--                 },
--                 t = {
--                     "<cmd>BitoAiCheckStyle<cr>",
--                     "Checks the code for style issues and suggests style improvements"
--                 },
--                 p = {
--                     "<cmd>BitoAiCheckPerformance<cr>",
--                     "Analyzes the code for performance issues and suggests optimizations"
--                 },
--             },
--             r = {
--                 "<cmd>BitoAiReadable<cr>",
--                 "Organizes the code to enhance readability and maintainability"
--             },
--             e = {
--                 "<cmd>BitoAiExplain<cr>",
--                 "Generates an explanation for the selected code"
--             },
--         }
--     },
--     w = {
--         name = 'Workspace',
--         a = {
--             function()
--                 workspaces.add()
--             end,
--             "add"
--         },
--         l = {
--             function()
--                 workspaces.list()
--             end,
--             "list"
--         },
--         r = {
--             function()
--                 workspaces.remove(workspaces.name())
--             end,
--             "remove current workspace"
--         },
--         o = {
--             function()
--                 workspaces.open()
--             end,
--             "open"
--         },
--         s = {
--             "<cmd>SessionsSave<cr>",
--             "save session"
--         },
--     },
--     b = {
--         name = "buffer",
--         p = {"<cmd>bp<cr>", "previous"},
--         n = {"<cmd>bn<cr>", "next"},
--         d = {"<cmd>bd<cr>", "delete"},
--         f = {"<cmd>bf<cr>", "first"},
--         l = {"<cmd>bl<cr>", "last"},
--         s = {"<cmd>ls<cr>", "list"},
--     },
--     f = {
--         name = "file", -- optional group name
--         f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--         r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
--         b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
--         g = { "<cmd>Telescope live_grep<cr>", "Find Words" },
--         w = { "<cmd>Telescope file_browser<cr>", "File Browser" },
--         k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--         m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--         t = { "<cmd>NvimTreeToggle<cr>", "Toggle FileTree" },
--         n = { "<cmd>DashboardNewFile<cr>", "New File" },
--         d = { "<cmd>e "..config_home.."/init.lua<cr>", "Open neovim configuration" },
--     },
--     --h = {
--     --    name = 'http rest client',
--     --    r = {function()
--     --        rest.run()
--     --    end, "Run the request under the cursor"},
--     --    p = {function()
--     --        rest.run(true)
--     --    end, "Preview the request cURL command"},
--     --    l = {function()
--     --        rest.last()
--     --    end, "Re-run the last request"},
--     --},
--     l = {
--         name = 'lsp',
--         g = {
--             name = 'Goto',
--             D = { vim.lsp.buf.declaration, "declaration" },
--             d = { vim.lsp.buf.definition, "definition" },
--             i = { vim.lsp.buf.implementation, "implementation" },
--             r = { vim.lsp.buf.references, "references" },
--             t = { vim.lsp.buf.type_definition, "type definition" },
--             s = { "<cmd>ClangdSwitchSourceHeader<cr>" , "switch source/header" },
--         },
--         p = {
--             name = 'Goto Preview',
--             d = { goto_preview.goto_preview_definition, "definition" },
--             i = { goto_preview.goto_preview_implementation, "implementation" },
--             r = { goto_preview.goto_preview_references, "references" },
--             t = { goto_preview.goto_preview_type_definition, "type definition" },
--             q = { goto_preview.close_all_win, "close" },
--         },
--         a = { vim.lsp.buf.code_action, "Code Action" },
--         r = { vim.lsp.buf.rename, "Rename" },
--         k = { vim.lsp.buf.hover, "Hover" },
--         h = { vim.lsp.buf.signature_help, "Signature Help" },
--         f = { vim.lsp.buf.formatting, "Format" },
--         w = {
--             name = "Workspace Folder",
--             a = { vim.lsp.buf.add_workspace_folder, "add" },
--             r = { vim.lsp.buf.remove_workspace_folder, "remove" },
--             l = { function()
--                 print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--             end, "list" },
--         },
--         s = {"<cmd>SymbolsOutline<cr>", "Open SymbolsOutline"},
--         c = {
--             name = 'Comment',
--             c = {
--                 function()
--                     neogen.generate({ type = 'class' })
--                 end,
--                 "class"
--             },
--             r = {
--                 function()
--                     neogen.generate({ type = 'func' })
--                 end,
--                 "function"
--             },
--             f = {
--                 function()
--                     neogen.generate({ type = 'file' })
--                 end,
--                 "file"
--             },
--             t = {
--                 function()
--                     neogen.generate({ type = 'type' })
--                 end,
--                 "type"
--             },
--         },
--     },
--     g = {
--         name = 'git',
--         g = { "<cmd>LazyGit<cr>", "LazyGit" },
--         c = { "<cmd>Telescope gitmoji<cr>", "gitmoji commit" },
--         s = { "<cmd>LazyGitConfig<cr>", "LazyGitConfig" },
--         f = { "<cmd>LazyGitFilter<cr>", "Project Commit" },
--         b = { "<cmd>LazyGitFilterCurrentFile<cr>", "BUffer Commit" },
--         d = {
--             name = 'Diff View',
--             h = { "<cmd>DiffviewFileHistory %<cr>", "File History" },
--             q = { "<cmd>DiffviewClose <cr>", "Close Diffview" },
--             r = { "<cmd>DiffviewRefresh<cr>", "Update Diffview" },
--         },
--     },
--     p = {
--         name = 'plug',
--         i = { "<cmd>Lazy install<cr>", "Install" },
--         c = { "<cmd>Lazy clean<cr>", "Clean" },
--         u = { "<cmd>Lazy update<cr>", "Update" },
--         s = { "<cmd>Lazy sync<cr>", "Sync" },
--         l = { "<cmd>Lazy log<cr>", "Log" },
--         h = { "<cmd>Lazy help<cr>", "Help" },
--     },
--     d = {
--         name = 'debug',
--         b = {"<cmd>lua require'dap'.toggle_breakpoint()<cr>", "breakpoint"},
--         c = {"<cmd>lua require'dap'.continue()<cr>", "continue"},
--         n = {"<cmd>:lua require'dap'.step_over()<cr>", "step over"},
--         i = {"<cmd>:lua require'dap'.step_into()<cr>", "step into"},
--         o = {"<cmd>:lua require'dap'.step_out()<cr>", "step out"},
--         h = {"<cmd>:lua require'dap.ui.widgets'.hover()<cr>", "view value under the cursor"},
--         r = {"<cmd>:lua require('dap').repl.open()<CR>", "repl open"},
--         l = {"<cmd>:lua require('dap').run_last()<CR>", "run last"},
--         q = {"<cmd>:lua require('dap').disconnect()<CR>", "disconnect"},
--         x = {"<cmd>:lua require('dapui').close()<CR>", "ui close"},
--     },
--     t = {
--         name = 'floaterm',
--         o = {[[<cmd>lua require("FTerm").toggle()<cr>]], "open"},
--     },
--     m = {
--         name = 'translate',
--         f = {"<cmd>Translate ZH -output=floating<cr>", "floating"},
--         s = {"<cmd>Translate ZH -output=split<cr>", "split"},
--         i = {"<cmd>Translate ZH -output=insert<cr>", "insert"},
--         r = {"<cmd>Translate ZH -output=replace<cr>", "replace"},
--     },
--     q = { "<cmd>qa<cr>", "quit" }
-- }, { prefix = "<leader>" })
