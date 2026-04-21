return {
  "quintin-lee/header.nvim",
  event = { "BufNewFile", "BufReadPost" },
  opts = {
    template_dir = vim.fn.stdpath("config") .. "/config/header/",
    -- 预设占位符
    placeholders = {
      ["{{AUTHOR}}"] = function()
        local handle = io.popen("git config user.name")
        local git_name = handle:read("*a"):gsub("%s+", "")
        handle:close()
        return (git_name ~= "" and git_name) or os.getenv("USER")
      end,
      ["{{DATE}}"] = function()
        return os.date("%Y-%m-%d %H:%M:%S")
      end,
      ["{{YEAR}}"] = function()
        return os.date("%Y")
      end,
    },
    templates = {
      ["*.sh"] = "bash.txt",
      ["*.c"] = "c.txt",
      ["*.cpp"] = "cpp.txt",
      ["*.py"] = "python.txt",
      ["*.js"] = "javascript.txt",
      ["*.ts"] = "typescript.txt",
      ["*.java"] = "java.txt",
      ["*.go"] = "go.txt",
      ["*.rs"] = "rust.txt",
      ["*.php"] = "php.txt",
      ["*.rb"] = "ruby.txt",
      ["*.swift"] = "swift.txt",
      ["*.lua"] = "lua.txt",
      ["*.R"] = "r.txt",
    },
  },
  config = function(_, opts)
    require("header").setup(opts)

    -- 自动更新或插入 "Last Modified" 逻辑
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("HeaderUpdate", { clear = true }),
      callback = function()
        -- 仅对特定文件类型启用，或者全局启用但跳过空缓冲区
        if vim.bo.buftype ~= "" or vim.fn.line("$") < 2 then return end

        local n_lines = math.min(vim.api.nvim_buf_line_count(0), 15)
        local lines = vim.api.nvim_buf_get_lines(0, 0, n_lines, false)
        local time_str = os.date("%Y-%m-%d %H:%M:%S")
        local found = false

        -- 1. 尝试查找并更新现有的 Last Modified
        for i, line in ipairs(lines) do
          if line:match("Last Modified:") then
            local new_line = line:gsub("Last Modified:.*", "Last Modified: " .. time_str)
            vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
            found = true
            break
          end
        end

        -- 2. 如果没找到，则寻找锚点（Date: 或 Author:）进行插入
        if not found then
          for i, line in ipairs(lines) do
            -- 增加对不同注释风格的支持
            if line:match("Date:") or line:match("Author:") or line:match("Created on") then
              -- 智能提取注释前缀，支持 " # ", " -- ", " // ", " * " 等
              local prefix = line:match("^(%s*[%#%-%/%*]+%s*)")
              if not prefix then
                  -- 如果正则提取失败，回退到根据 filetype 判断
                  local comment_string = vim.bo.commentstring
                  prefix = comment_string:gsub("%%s", "") or "# "
              end

              local new_line = prefix .. "Last Modified: " .. time_str
              vim.api.nvim_buf_set_lines(0, i, i, false, { new_line })
              break
            end
          end
        end
      end,
    })  end,
}
