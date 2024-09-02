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

require('core.basic')

vim.loader.enable()

local plugins = {
    -- theme
    {
        'navarasu/onedark.nvim',
        config = function()
            require('configs.theme')
        end,
    },

    -- 对齐线
    {
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
    },

    -- highlight the word under the cursor
    {
        'RRethy/vim-illuminate',
        config = function()
            require('configs.vim-illuminate')
        end,
    },

     -- 自动补齐括号,引号
    {
        'ZhiyuanLck/smart-pairs',
        event = 'InsertEnter',
        config = function()
            require('pairs'):setup()
        end,
    },

    -- 启动页
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('configs.dashboard')
        end,
        dependencies = {{'nvim-tree/nvim-web-devicons'}}
    },

    -- LSP
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('configs.lsp')
            require('configs.goto-preview')
        end,
        dependencies = {{
            "williamboman/mason.nvim",
            'neovim/nvim-lspconfig',
            'hrsh7th/nvim-cmp', -- Autocompletion plugin
            'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
            'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
            { 'L3MON4D3/LuaSnip', build = "make install_jsregexp"}, -- Snippets plugin
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            -- Lua Development for Neovim
            'tjdevries/nlua.nvim',
            'rmagatti/goto-preview',
            'ray-x/lsp_signature.nvim',
        }}
    },
    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup({})
        end,
    },
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
        event = "VeryLazy",
    },
    {
        'paopaol/cmp-doxygen',
        dependencies = {{
            'nvim-treesitter/nvim-treesitter-textobjects'
        }},
    },
    {
        "SmiteshP/nvim-navic",
        config = function()
            require('configs.nvim-navic')
        end,
    },

    -- Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the openscad language
    {
        'salkin-mada/openscad.nvim',
        dependencies = {{ 'L3MON4D3/LuaSnip' }},
    },

    -- 高亮增强
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            require('configs.nvim-treesitter')
        end,
    },

    {
        'm-demare/hlargs.nvim',
        config = function ()
            require('configs.hlargs')
        end,
    },

    -- 调试
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {{
            'mfussenegger/nvim-dap',
            'ravenxrz/DAPInstall.nvim',
            'theHamsta/nvim-dap-virtual-text',
            'mfussenegger/nvim-dap-python',
            'nvim-neotest/nvim-nio',
        }},
        event = "VeryLazy",
        config = function()
            require('configs.dap')
        end,
    },

    -- Comment 相关插件
    -- TODO 高亮
    {
        'folke/todo-comments.nvim',
        dependencies = {{ 'nvim-lua/plenary.nvim' }},
        config = function ()
            require('configs.todo-comments')
        end,
    },
    {
        'danymat/neogen',
        dependencies = {{ "nvim-treesitter/nvim-treesitter" }},
        event = "VeryLazy",
        config = function ()
            require('configs.neogen')
        end,
    },
    {
        'terrortylor/nvim-comment',
        event = "VeryLazy",
        config = function()
            require('nvim_comment').setup()
        end
    },

    -- git 相关插件
    {
        'kdheepak/lazygit.nvim',
        event = "VeryLazy",
        -- optional for floating window border decoration
        dependencies = {{
            "nvim-lua/plenary.nvim",
        }},
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({})
        end,
    },
    {
        'robert-oleynik/git-blame-virt.nvim',
        dependencies = {{ 'nvim-lua/plenary.nvim' }},
        config = function()
            require('configs.git-blame-virt')
        end,
    },
    {
        'sindrets/diffview.nvim',
        event = "VeryLazy",
        dependencies = {{ 'nvim-lua/plenary.nvim' }},
        config = function()
            require('configs.diffview')
        end,
    },

    -- http rest client
    --{
    --    'NTBBloodbath/rest.nvim',
    --    dependencies = {{ "nvim-lua/plenary.nvim" }},
    --    lazy = true,
    --    config = function()
    --        require('configs.rest')
    --    end,
    --},
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
            rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
        }
    },
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        dependencies = { "luarocks.nvim" },
        config = function()
            require("rest-nvim").setup()
        end,
    },

    -- 快速跳转
    {
        'ggandor/leap.nvim',
        event = "VeryLazy",
        config = function()
            require("leap").set_default_keymaps()
        end,
    },

    -- 代码折叠
    {
        'kevinhwang91/nvim-ufo',
        event = "VeryLazy",
        dependencies = {{ 'kevinhwang91/promise-async' }},
        config = function()
            require('configs.nvim-ufo')
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },

    -- whichkey
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            require('configs.keymap')
        end,
    },

    -- 状态栏，buffer 栏美化
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = {{'nvim-tree/nvim-web-devicons', 'nvim-lualine/lualine.nvim'}},
        config = function()
            require('configs.status-buffer')
        end,
    },

    -- 文件大纲/符号表
    {
        'simrat39/symbols-outline.nvim',
        event = "VeryLazy",
        config = function()
            require('configs.symbols-outline')
        end,
    },

    -- Tabnine client
    {
        'codota/tabnine-nvim',
        build = "./dl_binaries.sh",
        config = function()
            require('configs.tabnine')
        end,
    },
    -- Bito AI
    {
        'zhenyangze/vim-bitoai',
        event = "VeryLazy",
    },

    -- 翻译
    {
        'uga-rosa/translate.nvim',
        event = "VeryLazy",
        config = function()
            require('configs.translate')
        end,
    },

    -- 浮动终端
    {
        'numToStr/FTerm.nvim',
        event = "VeryLazy",
        config = function()
            require('configs.floaterm')
        end,
    },

    -- workspace manager
    {
        'natecraddock/workspaces.nvim',
        event = "VeryLazy",
        dependencies = {{
            'natecraddock/sessions.nvim',
        }},
        config = function()
            require('configs.workspaces')
        end,
    },

     -- 文件搜索
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        dependencies = {{
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope-file-browser.nvim',
            {'nvim-telescope/telescope-frecency.nvim', dependencies = { 'tami5/sqlite.lua' } },
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-symbols.nvim',
            'quintin-lee/telescope-gitmoji.nvim',
        }},
        config = function()
            require('configs.telescope')
        end,
    },

    -- ui 美化
    {
        'stevearc/dressing.nvim',
        event = "VeryLazy",
        config = function()
            require('configs.dressing')
        end,
    },
    -- 消息通知美化
    {
        'rcarriga/nvim-notify',
        event = "VeryLazy",
        config = function()
            require('configs.vim-notify')
        end,
    },
    {
        'folke/noice.nvim',
        event = "VeryLazy",
        dependencies = {
            'MunifTanjim/nui.nvim'
        },
        config = function()
            require('configs.noice')
        end,
    },
    -- 命令行美化
    {
        'gelguy/wilder.nvim',
        event = "VeryLazy",
        dependencies = {{ 'romgrk/fzy-lua-native' }},
        config = function()
            require('configs.wilder')
        end,
    },
}

require("lazy").setup(plugins, opts)

