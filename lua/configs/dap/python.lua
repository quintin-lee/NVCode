require('dap-python').setup('python')
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Python launch configuration',
  program = '${file}',
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})
