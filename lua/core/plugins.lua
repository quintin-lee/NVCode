local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- 主题配色
    use 'navarasu/onedark.nvim'
    use 'EdenEast/nightfox.nvim'

    -- 优化启动时间
    use 'nathom/filetype.nvim'
    use {
        'lewis6991/impatient.nvim',
        config = function()
            require('impatient')
        end
    }

    -- 对齐线
    use "lukas-reineke/indent-blankline.nvim"

    -- highlight the word under the cursor
    use 'RRethy/vim-illuminate'

    -- 启动页
    use 'glepnir/dashboard-nvim'

    -- 文件搜索
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-frecency.nvim', requires = { 'tami5/sqlite.lua' } },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { 'nvim-telescope/telescope-symbols.nvim' },
            { 'quintin-lee/telescope-gitmoji.nvim' },
        }
    }

    -- LSP 自动补全
    use {
        "williamboman/nvim-lsp-installer",
        requires = {
            "neovim/nvim-lspconfig",
            'hrsh7th/nvim-cmp', -- Autocompletion plugin
            'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
            'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
            'L3MON4D3/LuaSnip', -- Snippets plugin
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu', },
            -- Lua Development for Neovim
            'tjdevries/nlua.nvim',
            'nvim-lua/completion-nvim',
            'rmagatti/goto-preview',
            'ray-x/lsp_signature.nvim',
        }
    }
    -- 自动补齐括号,引号
    use { 'ZhiyuanLck/smart-pairs', event = 'InsertEnter', config = function() require('pairs'):setup() end }
    -- 语法检查，语法高亮
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Syntax highlighting, cheatsheet, snippets, offline manual and fuzzy help plugin for the openscad language
    use {
        'salkin-mada/openscad.nvim',
        requires = 'L3MON4D3/LuaSnip'
    }
    -- 文件树
    --use {
    --    'kyazdani42/nvim-tree.lua',
    --    requires = {
    --        'kyazdani42/nvim-web-devicons', -- optional, for file icon
    --    },
    --    tag = 'nightly' -- optional, updated every week. (see issue #1193)
    --}
    -- 文件大纲/符号表
    use 'simrat39/symbols-outline.nvim'
    -- 状态栏/buffer
    use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
    -- 调试
    use {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "ravenxrz/DAPInstall.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap-python",
    }

    -- git 插件
    use 'kdheepak/lazygit.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
    use {
        'robert-oleynik/git-blame-virt.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require'git-blame-virt'.setup {}
        end
    }
    -- git diffview
    use {
        'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }

    -- 快捷键绑定
    use { 'folke/which-key.nvim' }

    -- http rest client
    use {
        'NTBBloodbath/rest.nvim',
        requires = { "nvim-lua/plenary.nvim" },
        opt = false,
    }

    -- 浮动终端
    use 'doums/floaterm.nvim'

    -- 翻译
    use 'uga-rosa/translate.nvim'

    -- Comment 相关插件
    -- TODO 高亮
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }
    use {
        'danymat/neogen',
        requires = "nvim-treesitter/nvim-treesitter",
    }
    use {
        'terrortylor/nvim-comment',
        config = function()
            require('nvim_comment').setup()
        end
    }

    -- nvim tui 美化
    use 'stevearc/dressing.nvim'

    -- workspace manager
    use {
        'natecraddock/workspaces.nvim',
        requires = {
            'natecraddock/sessions.nvim',
        },
    }

    use {
        'kevinhwang91/nvim-bqf',
        requires = {
            'junegunn/fzf',
            run = function()
                vim.fn['fzf#install']()
            end,
        },
        ft = 'qf'
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end,
    config = {
        display = {
            open_fn = require('packer.util').float,
        }
    } })
