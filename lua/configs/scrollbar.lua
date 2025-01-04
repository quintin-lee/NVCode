-- 创建或覆盖 ScrollbarInit augroup 并定义自动命令
vim.api.nvim_create_augroup('ScrollbarInit', { clear = true })

-- 定义自动命令并关联到 ScrollbarInit augroup
vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized", "QuitPre" }, {
    group = 'ScrollbarInit',
    pattern = '*',
    callback = function()
        require('scrollbar').show()
    end,
    desc = 'Show scrollbar on window scroll, resize or before quit'
})

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
    group = 'ScrollbarInit',
    pattern = '*',
    callback = function()
        require('scrollbar').show()
    end,
    desc = 'Show scrollbar when entering a window or gaining focus'
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "BufWinLeave", "FocusLost" }, {
    group = 'ScrollbarInit',
    pattern = '*',
    callback = function()
        require('scrollbar').clear()
    end,
    desc = 'Clear scrollbar when leaving a window, buffer or losing focus'
})
