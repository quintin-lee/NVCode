-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencodings ="utf8,ucs-bom,gbk,cp936,gb2312,gb18030"
-- jk移动时光标下上方保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- 使用相对行号
vim.wo.number = true
vim.wo.relativenumber = true
-- 高亮所在行
vim.wo.cursorline = true
-- 显示左侧图标指示列，并设置固定宽度
vim.wo.signcolumn = "yes:2"  -- 使用自动模式，避免不必要的宽度
-- 右侧参考线，超过表示代码太长了，考虑换行
vim.wo.colorcolumn = "120"
-- 缩进2个空格等于一个Tab
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
-- >> << 时移动长度
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
-- 新行对齐当前行，空格替代tab
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true
-- 搜索高亮
vim.o.hlsearch = true
-- 边输入边搜索
vim.o.incsearch = true
-- 使用增强状态栏后不再需要 vim 的模式提示
vim.o.showmode = false
-- 命令行高为2，提供足够的显示空间
vim.o.cmdheight = 2
-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true
vim.bo.autoread = true
-- 禁止折行
vim.o.wrap = false
vim.wo.wrap = false
-- 行结尾可以跳到下一行
vim.o.whichwrap = 'b,s,<,>,[,],h,l'
-- 允许隐藏被修改过的buffer
vim.o.hidden = true
-- 鼠标模式设置
vim.o.mouse = "a"
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 300
-- 等待mappings
vim.o.timeoutlen = 500
-- split window 从下边和右边出现
vim.o.splitbelow = true
vim.o.splitright = true
-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect"
-- 样式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 不可见字符的显示，这里只把空格显示为一个点
--vim.o.list = true
--vim.o.listchars = "space:·"
-- 补全增强
vim.o.wildmenu = true
-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.pumheight = 10
-- always show tabline
vim.o.showtabline = 2
-- 配置剪切板
vim.opt.clipboard = "unnamedplus"

-- 记录文件上次编辑和浏览位置
vim.cmd [[
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif
]]

-- helps jumps out of the difinition without too many C-o
vim.cmd [[
    set tagfunc=v:lua.vim.lsp.tagfunc
    set jumpoptions+=stack
]]

-- 默认不折叠代码
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
