-- 基础配置
require('core.basic')

-- 插件管理
require('core.plugins')
require('core.dashboard')
require('configs.telescope')
require('configs.status-buffer')
--require('configs.nvim-tree')
require('configs.lsp')
require('configs.dap')
require('configs.nvim-treesitter')
require('configs.symbols-outline')
require('configs.rest')
require('configs.floaterm')
require('configs.vim-illuminate')
require('configs.translate')
require('configs.todo-comments')
require('configs.dressing')
require('configs.neogen')
require('configs.diffview')
require('configs.workspaces')
require('configs.git-blame-virt')
require('configs.goto-preview')
require('configs.wilder')

-- 主题配置
require('core.theme')

-- 快捷键绑定
require('core.keymap')
