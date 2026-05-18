-- 离线模式优化：禁用需要网络连接的 AI 插件
local is_offline = os.getenv("NVIM_OFFLINE") == "1"

return {
  -- 1. Avante AI 助手
  {
    "yetone/avante.nvim",
    enabled = not is_offline,
  },

  -- 2. GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    enabled = not is_offline,
  },

  -- 3. CodeCompanion (Gemini/Qwen)
  {
    "olimorris/codecompanion.nvim",
    enabled = not is_offline,
  },

  -- 4. 相关的补充插件
  {
    "Kaiser-Yang/blink-cmp-avante",
    enabled = not is_offline,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = not is_offline,
  },
}
