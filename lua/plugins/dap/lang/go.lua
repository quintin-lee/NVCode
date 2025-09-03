local dap = require('dap')

local dlv_tool_path = vim.fn.exepath('dlv')  -- Adjust to where delve is installed

dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = {os.getenv('HOME') .. '/.local/vscode-go/extension/dist/debugAdapter.js'};
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = dlv_tool_path
  },
}

dap.listeners.on_config = dap.listeners.on_config or {}
dap.listeners.on_config["inject_dlv_path"] = function(config)
  if config.type == "go" and not config.dlvToolPath then
    config.dlvToolPath = dlv_tool_path
  end
  -- 返回修改后的配置供后续使用
  return config
end
