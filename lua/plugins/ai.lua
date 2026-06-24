-- 离线模式优化：禁用需要网络连接的 AI 插件
local is_offline = os.getenv("NVIM_OFFLINE") == "1"

return {
  -- 1. GitHub Copilot（行内补全）
  {
    "zbirenbaum/copilot.lua",
    enabled = not is_offline,
  },

  -- 2. CodeCompanion (OpenCode/Gemini/Qwen)
  {
    "olimorris/codecompanion.nvim",
    enabled = not is_offline,
  },

  -- 3. Copilot 补全源（配合 blink.cmp）
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = not is_offline,
  },
}
