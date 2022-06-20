local wk = require("which-key")

vim.g.mapleader = " "
vim.g.maplocalleader = " "


local rest = require('rest-nvim')

wk.register({
    b = {
        name = "buffer",
        p = {"<cmd>bp<cr>", "previous"},
        n = {"<cmd>bp<cr>", "next"},
    },
    f = {
        name = "file", -- optional group name
        f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
        b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
        g = { "<cmd>Telescope live_grep<cr>", "Find Words" },
        w = { "<cmd>Telescope file_browser<cr>", "File Browser" },
        t = { "<cmd>NvimTreeToggle<cr>", "Toggle FileTree" },
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
            t = { vim.lsp.buf.type_definition, "type definition" }
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
        s = {"<cmd>SymbolsOutline<cr>", "Open SymbolsOutline"}
    },
    g = {
        name = 'git',
        g = { "<cmd>LazyGit<cr>", "LazyGit" },
        c = { "<cmd>LazyGitConfig<cr>", "LazyGitConfig" },
        f = { "<cmd>LazyGitFilter<cr>", "Project Commit" },
        b = { "<cmd>LazyGitFilterCurrentFile<cr>", "BUffer Commit" },
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
    }
}, { prefix = "<leader>" })
