local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- 基础配置
require('core.basic')

-- 插件管理
require('core.plugins')
require('core.dashboard')
require('configs.telescope')
require('configs.status-buffer')
require('configs.nvim-tree')
require('configs.lsp')
require('configs.dap')
require('configs.nvim-treesitter')
require('configs.symbols-outline')
require('configs.rest')
require('configs.floaterm')
require('configs.vim-illuminate')
require('impatient')

-- 主题配置
require('core.theme')

-- 快捷键绑定
require('core.keymap')
