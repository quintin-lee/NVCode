-- lua/tools/gitmoji_commit.lua
-- Gitmoji commit using vim.ui.select (backed by Snacks Picker)

local M = {}

M.commit = function()
  local emojis = require("tools.emojis")

  local items = vim.tbl_map(function(e)
    return {
      key = e.key,
      emoji = e.value,
      desc = e.description,
      display = e.value .. "  " .. e.key .. "  " .. e.description,
    }
  end, emojis)

  vim.ui.select(items, {
    prompt = "🐶  Gitmoji Commit",
    format_item = function(item)
      return item.display
    end,
  }, function(entry)
    if not entry then
      return
    end

    vim.ui.input({ prompt = "Scope: " .. entry.key .. " " }, function(scope)
      if not scope then
        return
      end

      local subject = string.format("%s(%s): %s ", entry.key, scope, entry.emoji)

      -- 窗口布局计算
      local width = math.floor(vim.o.columns * 0.7)
      local height = math.floor(vim.o.lines * 0.5)

      -- 创建主缓冲区
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "gitcommit"
      vim.bo[buf].buftype = "acwrite"
      vim.bo[buf].bufhidden = "wipe"

      -- 开启主浮动窗口
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
      vim.wo[win].winblend = 10
      vim.wo[win].winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"

      -- 辅助提示窗
      local hint_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(hint_buf, 0, -1, false, { " [   C-s] Commit | [   C-c] Cancel " })
      vim.bo[hint_buf].modifiable = false

      local hint_win = vim.api.nvim_open_win(hint_buf, false, {
        relative = "win",
        win = win,
        width = width,
        height = 1,
        row = height,
        col = -1,
        style = "minimal",
        border = "rounded",
        focusable = false,
      })
      vim.wo[hint_win].winblend = 15

      -- 初始化内容
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { subject, "", "" })
      vim.api.nvim_win_set_cursor(win, { 1, #subject })
      vim.cmd("startinsert!")

      -- 清理逻辑
      local function cleanup()
        local wins = { win, hint_win }
        for _, w in ipairs(wins) do
          if w and vim.api.nvim_win_is_valid(w) then
            vim.api.nvim_win_close(w, true)
          end
        end
      end

      -- 提交逻辑
      local function do_commit()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        lines = vim.tbl_filter(function(line)
          return line ~= ""
        end, lines)
        if #lines == 0 then
          vim.notify("Commit message is empty!", vim.log.levels.ERROR)
          return
        end

        local tmp = vim.fn.tempname()
        vim.fn.writefile(lines, tmp)

        if vim.g.loaded_fugitive then
          vim.cmd("G commit -F " .. tmp)
          pcall(vim.uv.fs_unlink, tmp)
          cleanup()
          vim.notify("🚀 Commit successful!", vim.log.levels.INFO)
        else
          local output = vim.fn.system({ "git", "commit", "-F", tmp })
          pcall(vim.uv.fs_unlink, tmp)
          cleanup()
          if vim.v.shell_error ~= 0 then
            vim.notify("Git commit failed:\n" .. output, vim.log.levels.ERROR)
          else
            vim.notify("🚀 Commit successful!", vim.log.levels.INFO)
          end
        end
      end

      -- 快捷键映射
      local map_opts = { buffer = buf, remap = false, silent = true }
      vim.keymap.set({ "n", "i" }, "<C-s>", function()
        vim.cmd("stopinsert")
        do_commit()
      end, map_opts)

      vim.keymap.set({ "n", "i" }, "<C-c>", cleanup, map_opts)

      -- 窗口关闭自动清理
      vim.api.nvim_create_autocmd("WinClosed", {
        buffer = buf,
        once = true,
        callback = cleanup,
      })
    end)
  end)
end

return M
