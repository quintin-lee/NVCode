-- lua/tools/gitmoji_commit.lua
-- Module for gitmoji commit functionality

local M = {}

M.get_gitmoji_config = function()
  return {
    commit_type = require("tools.emojis"), -- 确保该文件路径正确
    action = function(entry)
      vim.ui.input({ prompt = "Scope: " .. entry.key .. " " }, function(scope)
        if not scope then
          return
        end

        local subject = string.format("%s(%s): %s ", entry.key, scope, entry.value)

        -- 1. 窗口布局计算
        local width = math.floor(vim.o.columns * 0.7)
        local height = math.floor(vim.o.lines * 0.5)

        -- 2. 创建主缓冲区
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].filetype = "gitcommit"
        vim.bo[buf].buftype = "acwrite"
        vim.bo[buf].bufhidden = "wipe"

        -- 3. 开启主浮动窗口
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = (vim.o.lines - height) / 2,
          col = (vim.o.columns - width) / 2,
          style = "minimal",
          border = "rounded",
          title = " Git Commit Message ",
          title_pos = "center",
        })
        -- 设置透明度级别 (0 为不透明，100 为全透明)
        -- 通常设置为 10-20 效果最佳
        vim.wo[win].winblend = 10

        -- 将窗口背景与普通背景链接，确保透明效果生效
        -- NormalFloat 是浮动窗口背景，FloatBorder 是边框
        vim.wo[win].winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"

        -- 4. 辅助提示窗 (Hint Box)
        local hint_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, { " [   C-s] Commit | [   C-c] Cancel " })
        vim.bo[hint_buf].modifiable = false

        local hint_win = vim.api.nvim_open_win(hint_buf, false, {
          relative = "win",
          win = win,
          width = width,
          height = 1,
          row = height,
          col = -1, -- 贴合在底部边框
          style = "minimal",
          border = "rounded",
          focusable = false,
        })
        vim.wo[hint_win].winblend = 15

        -- 5. 初始化内容
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { subject, "", "" })
        vim.api.nvim_win_set_cursor(win, { 1, #subject })
        vim.cmd("startinsert!") -- 自动进入插入模式并移动到行尾

        -- 6. 清理逻辑封装
        local function cleanup()
          local wins = { win, hint_win }
          for _, w in ipairs(wins) do
            if w and vim.api.nvim_win_is_valid(w) then
              vim.api.nvim_win_close(w, true)
            end
          end
        end

        -- 7. 提交逻辑
        local function do_commit()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          -- 过滤空行
          lines = vim.tbl_filter(function(line)
            return line ~= ""
          end, lines)
          if #lines == 0 then
            vim.notify("Commit message is empty!", vim.log.levels.ERROR)
            return
          end

          local tmp = vim.fn.tempname()
          vim.fn.writefile(lines, tmp)

          -- 优先使用 Fugitive，否则使用系统 git
          local cmd = (vim.g.loaded_fugitive and "G" or "!git") .. " commit -F " .. tmp
          vim.cmd(cmd)

          pcall(vim.uv.fs_unlink, tmp)
          cleanup()
          vim.notify("🚀 Commit successful!", vim.log.levels.INFO)
        end

        -- 8. 快捷键映射 (Buffer-local)
        local map_opts = { buffer = buf, remap = false, silent = true }
        vim.keymap.set({ "n", "i" }, "<C-s>", function()
          vim.cmd("stopinsert")
          do_commit()
        end, map_opts)

        vim.keymap.set({ "n", "i" }, "<C-c>", cleanup, map_opts)

        -- 9. 自动命令：如果窗口被意外关闭，清理提示窗
        vim.api.nvim_create_autocmd("WinClosed", {
          buffer = buf,
          once = true,
          callback = cleanup,
        })
      end)
    end,
  }
end

return M
