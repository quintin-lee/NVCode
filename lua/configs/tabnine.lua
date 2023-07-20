require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<C-C>",
  dismiss_keymap = "<C-L]>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"TelescopePrompt"}
})
