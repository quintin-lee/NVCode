local config_home = vim.fn.stdpath("config")

-- 创建一个自动命令组来管理所有模板相关的自动命令
local template_augroup = vim.api.nvim_create_augroup('TemplateAutoCommands', { clear = true })

-- 模板插入函数
local function insert_template(pattern, template_path)
  -- 检查模板文件是否存在
  if vim.fn.filereadable(template_path) == 0 then
    vim.notify(string.format("Template file not found: %s", template_path), vim.log.levels.WARN)
    return
  end

  vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = pattern,
    callback = function()
      -- 插入模板文件内容
      vim.cmd('0r ' .. template_path)
      -- 删除尾部空行
      if pattern ~= '*.sh' then
          vim.cmd([[%s/\n\+\%$//e]])
      end

      vim.ui.input({
        prompt = "Enter your name: ",
        default = "",
      }, function(author_name)
        local bufnr = vim.api.nvim_get_current_buf()
        local date = os.date("%Y-%m-%d")
        local filename = vim.fn.expand('%')
        -- 读取缓冲区内容
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        -- 替换 {{DATE}} 和 {{AUTHOR}}
        for i, line in ipairs(lines) do
          lines[i] = line:gsub("{{DATE}}", date):gsub("{{AUTHOR}}", author_name):gsub("{{FILENAME}}", filename)
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

        -- 查找 <!-- CURSOR --> 标记并移动光标到该位置
        local cursor_pos = vim.fn.search('<\\!-- CURSOR -->', 'n')
        if cursor_pos > 0 then
          vim.api.nvim_win_set_cursor(0, {cursor_pos, 0})
          -- 删除 <!-- CURSOR --> 标记
          vim.cmd(cursor_pos .. 'delete _')
        else
          -- 如果没有找到 <!-- CURSOR --> 标记，跳转到文件末尾
          local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf())
          if line_count > 0 then
            vim.api.nvim_win_set_cursor(0, {line_count, 0})
          end
        end
      end)
    end,
    group = template_augroup
  })
end

-- 注册模板
local templates = {
  ['*.py'] = '/lua/plugins/header/templates/python.txt',
  ['*.sh'] = '/lua/plugins/header/templates/bash.txt',
  ['*.c'] = '/lua/plugins/header/templates/c.txt',
  ['*.cpp'] = '/lua/plugins/header/templates/cpp.txt',
}

-- 注册所有模板
for pattern, template in pairs(templates) do
  insert_template(pattern, config_home .. template)
end