local config_home = vim.fn.stdpath("config")

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.py',
  command = '0r ' ..config_home.. '/lua/header/templates/python.txt'
})

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.sh',
  command = '0r ' ..config_home.. '/lua/header/templates/bash.txt'
})

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = function()
    vim.api.nvim_command('normal G')
  end
})
