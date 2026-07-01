-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 基础选项设置
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- 覆盖 LazyVim 默认缩进（2 → 4）
opt.shiftwidth = 4
opt.tabstop = 4

-- 高亮当前列（LazyVim 未默认开启）
opt.cursorcolumn = true

-- 启用标题栏（用于窗口管理器识别 neovim 实例）
opt.title = true

-- 依赖检查函数
local function check_dependencies()
  local dependencies = {
    { cmd = "rg", name = "ripgrep", desc = "用于快速文本搜索 (Snacks Picker)" },
    { cmd = "fd", name = "fd", desc = "用于快速文件查找 (Snacks Picker)" },
    { cmd = "git", name = "git", desc = "版本控制核心" },
    { cmd = "gemini", name = "Gemini CLI", desc = "AI 助手 (CodeCompanion)" },
    { cmd = "qwen", name = "Qwen CLI", desc = "AI 助手 (CodeCompanion)" },
  }

  local missing = {}
  for _, dep in ipairs(dependencies) do
    if vim.fn.exepath(dep.cmd) == "" then
      table.insert(missing, string.format("%s (%s)", dep.name, dep.desc))
    end
  end

  if #missing > 0 then
    vim.notify(
      "NVCode is missing some critical dependencies, some features may be limited:\n- " .. table.concat(missing, "\n- "),
      vim.log.levels.WARN,
      { title = "Dependency Check" }
    )
  end

end

-- 执行检查
check_dependencies()

