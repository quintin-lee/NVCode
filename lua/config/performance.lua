-- 性能监控和错误处理配置
return {
  -- 启用诊断
  diagnostics = {
    enable = true,
    timeout = 1000,
  },
  
  -- 错误处理
  error_handling = {
    -- 全局错误捕获
    setup = function()
      -- 捕获未处理的错误
      vim.on_exit(function(code)
        if code ~= 0 then
          vim.notify("Neovim exited with error code: " .. code, vim.log.levels.ERROR)
        end
      end)
      
      -- 捕获 Lua 错误
      lua_error_handler = function(err)
        vim.notify("Lua error: " .. tostring(err), vim.log.levels.ERROR)
        return err
      end
    end,
  },
  
  -- 性能监控
  performance = {
    -- 启用启动时间统计
    enable_startup_stats = true,
    
    -- 监控大文件加载
    large_file_threshold = 1024 * 1024, -- 1MB
    
    -- 优化高亮性能
    max_file_size = 50 * 1024 * 1024, -- 50MB
  },
}