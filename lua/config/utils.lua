-- 通用配置辅助函数
local M = {}

-- 安全加载模块
M.safe_require = function(module_name, default)
  local ok, module = pcall(require, module_name)
  if ok then
    return module
  end
  return default
end

-- 错误处理包装器
M.safe_call = function(func)
  local ok, err = pcall(func)
  if not ok then
    vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- 获取Git用户名
M.get_git_username = function()
  local handle = io.popen("git config user.name 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return result or os.getenv("USER") or "Unknown"
  end
  return os.getenv("USER") or "Unknown"
end

return M