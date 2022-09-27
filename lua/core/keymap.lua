local wk = require("which-key")

vim.g.mapleader = " "
vim.g.maplocalleader = " "


local rest = require('rest-nvim')
local neogen = require('neogen')
local workspaces = require('workspaces')
local goto_preview = require('goto-preview')

local home = os.getenv('HOME')

wk.register({
    w = {
        name = 'Workspace',
        a = {
            function()
                workspaces.add()
            end,
            "add"
        },
        l = {
            function()
                workspaces.list()
            end,
            "list"
        },
        r = {
            function()
                workspaces.remove(workspaces.name())
            end,
            "remove current workspace"
        },
        o = {
            function()
                workspaces.open()
            end,
            "open"
        },
        s = {
            "<cmd>SessionsSave<cr>",
            "save session"
        },
    },
    b = {
        name = "buffer",
        p = {"<cmd>bp<cr>", "previous"},
        n = {"<cmd>bn<cr>", "next"},
        d = {"<cmd>bd<cr>", "delete"},
        f = {"<cmd>bf<cr>", "first"},
        l = {"<cmd>bl<cr>", "last"},
        s = {"<cmd>bs<cr>", "list"},
    },
    f = {
        name = "file", -- optional group name
        f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
        b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
        g = { "<cmd>Telescope live_grep<cr>", "Find Words" },
        w = { "<cmd>Telescope file_browser<cr>", "File Browser" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        t = { "<cmd>NvimTreeToggle<cr>", "Toggle FileTree" },
        n = { "<cmd>DashboardNewFile<cr>", "New File" },
        d = { "<cmd>e "..home.."/.config/nvim/init.lua<cr>", "Open neovim configuration" },
    },
    h = {
        name = 'http rest client',
        r = {function()
            rest.run()
        end, "Run the request under the cursor"},
        p = {function()
            rest.run(true)
        end, "Preview the request cURL command"},
        l = {function()
            rest.last()
        end, "Re-run the last request"},
    },
    l = {
        name = 'lsp',
        g = {
            name = 'Goto',
            D = { vim.lsp.buf.declaration, "declaration" },
            d = { vim.lsp.buf.definition, "definition" },
            i = { vim.lsp.buf.implementation, "implementation" },
            r = { vim.lsp.buf.references, "references" },
            t = { vim.lsp.buf.type_definition, "type definition" },
            s = { "<cmd>ClangdSwitchSourceHeader<cr>" , "switch source/header" },
        },
        p = {
            name = 'Goto Preview',
            d = { goto_preview.goto_preview_definition, "definition" },
            i = { goto_preview.goto_preview_implementation, "implementation" },
            r = { goto_preview.goto_preview_references, "references" },
            t = { goto_preview.goto_preview_type_definition, "type definition" },
            q = { goto_preview.close_all_win, "close" },
        },
        a = { vim.lsp.buf.code_action, "Code Action" },
        r = { vim.lsp.buf.rename, "Rename" },
        k = { vim.lsp.buf.hover, "Hover" },
        h = { vim.lsp.buf.signature_help, "Signature Help" },
        f = { vim.lsp.buf.formatting, "Format" },
        w = {
            name = "Workspace Folder",
            a = { vim.lsp.buf.add_workspace_folder, "add" },
            r = { vim.lsp.buf.remove_workspace_folder, "remove" },
            l = { function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "list" },
        },
        s = {"<cmd>SymbolsOutline<cr>", "Open SymbolsOutline"},
        c = {
            name = 'Comment',
            c = {
                function()
                    neogen.generate({ type = 'class' })
                end,
                "class"
            },
            r = {
                function()
                    neogen.generate({ type = 'func' })
                end,
                "function"
            },
            f = {
                function()
                    neogen.generate({ type = 'file' })
                end,
                "file"
            },
            t = {
                function()
                    neogen.generate({ type = 'type' })
                end,
                "type"
            },
        },
    },
    g = {
        name = 'git',
        g = { "<cmd>LazyGit<cr>", "LazyGit" },
        c = { "<cmd>LazyGitConfig<cr>", "LazyGitConfig" },
        f = { "<cmd>LazyGitFilter<cr>", "Project Commit" },
        b = { "<cmd>LazyGitFilterCurrentFile<cr>", "BUffer Commit" },
        d = {
            name = 'Diff View',
            h = { "<cmd>DiffviewFileHistory %<cr>", "File History" },
            q = { "<cmd>DiffviewClose <cr>", "Close Diffview" },
            r = { "<cmd>DiffviewRefresh<cr>", "Update Diffview" },
        },
    },
    p = {
        name = 'plug',
        i = { "<cmd>PackerInstall<cr>", "Install" },
        c = { "<cmd>PackerClean<cr>", "Clean" },
        b = { "<cmd>PackerCompile<cr>", "Compile" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        t = { "<cmd>PackerStatus<cr>", "Status" },
    },
    d = {
        name = 'debug',
        b = {"<cmd>lua require'dap'.toggle_breakpoint()<cr>", "breakpoint"},
        c = {"<cmd>lua require'dap'.continue()<cr>", "continue"},
        n = {"<cmd>:lua require'dap'.step_over()<cr>", "step over"},
        i = {"<cmd>:lua require'dap'.step_into()<cr>", "step into"},
        o = {"<cmd>:lua require'dap'.step_out()<cr>", "step out"},
        h = {"<cmd>:lua require'dap.ui.widgets'.hover()<cr>", "view value under the cursor"},
    },
    t = {
        name = 'floaterm',
        o = {[[<cmd>lua require'floaterm'.open({row=1})<cr>]], "open"},
    },
    m = {
        name = 'translate',
        f = {"<cmd>Translate ZH -output=floating<cr>", "floating"},
        s = {"<cmd>Translate ZH -output=split<cr>", "split"},
        i = {"<cmd>Translate ZH -output=insert<cr>", "insert"},
        r = {"<cmd>Translate ZH -output=replace<cr>", "replace"},
    },
    q = { "<cmd>qa<cr>", "quit" }
}, { prefix = "<leader>" })
