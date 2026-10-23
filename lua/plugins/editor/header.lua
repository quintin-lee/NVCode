--[header] 自动文件头模板
-- 支持 C/C++/Python/Go/Rust/JS/TS 等多语言
-- 含自动更新 Last Modified 时间戳功能

return {
  "quintin-lee/header.nvim",
  event = { "BufNewFile", "BufReadPost" },
  opts = {
    template_dir = vim.fn.stdpath("config") .. "/lua/header-templates/",
    -- 新建文件时弹出 "Author: " 输入框，预填上次输入的值（记忆）
    -- 回车沿用 / 修改后写回；空输入则回退到 default_author
    enable_persistent_author = true,
    author_file = vim.fn.stdpath("data") .. "/header_author.txt",
    -- 兜底：从未输入过或清空时使用（git user.name 优先，回退 $USER）
    default_author = (function()
      local handle = io.popen("git config user.name 2>/dev/null")
      local name = handle and handle:read("*a"):gsub("%s+$", "") or ""
      if handle then handle:close() end
      return (name ~= "" and name) or os.getenv("USER") or "Unknown"
    end)(),
    -- 占位符由插件硬编码提供，此处不可扩展：
    --   {{DATE}} %Y-%m-%d / {{AUTHOR}} / {{FILENAME}} / {{YEAR}} / {{TIME}}
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
        -- 仅对普通文件启用；空缓冲区（line("$")==1 且第 1 行为空）跳过
        if vim.bo.buftype ~= "" then
          return
        end
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
          return
        end

        -- 获取前 15 行内容，避免处理过长文件
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

        -- 2. 如果没找到，则插入到元数据块的末尾。
        --    不能简单"插在某个锚点之后"：模板的元数据行顺序各异
        --    （File/Author/Date/Created on），以 Author 为锚点会插在
        --    Date 或 Created on 之前，破坏既定顺序。
        --    正确做法：取前 15 行内最后一个元数据行，插在它后面。
        if not found then
          local meta_patterns = { "File:", "Author:", "Date:", "Created on", "Last Modified:" }
          local last_idx = nil
          local last_prefix = nil

          for i = 1, n_lines do
            for _, pattern in ipairs(meta_patterns) do
              if lines[i]:match(pattern) then
                last_idx = i
                -- 智能提取注释前缀，支持 " # ", " -- ", " // ", " * " 等
                last_prefix = lines[i]:match("^(%s*[%#%-%/%*]+%s*)")
                break
              end
            end
          end

          if last_idx then
            if not last_prefix then
              -- 如果正则提取失败，回退到根据 filetype 判断
              local comment_string = vim.bo.commentstring
              last_prefix = comment_string:gsub("%%s", "") or "# "
            end

            local new_line = last_prefix .. "Last Modified: " .. time_str
            -- last_idx 是 1-indexed 的行号，插到它之后
            vim.api.nvim_buf_set_lines(0, last_idx, last_idx, false, { new_line })
          end
        end
      end,
    })
  end,
}
