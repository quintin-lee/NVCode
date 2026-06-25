--[media] 多媒体支持
-- image.nvim：在 Kitty 终端中内嵌渲染 markdown 图片

return {
  "3rd/image.nvim",
  event = "VeryLazy",
  opts = {
    backend = "kitty",
    tmux_show_only_in_active_window = false,
    integrations = {
      markdown = {
        enabled = true,
        filetypes = { "markdown", "vimwiki" },
        clear_in_insert_mode = false,
        only_render_image_at_cursor = false,
      },
    },
    max_width_window_percentage = 100,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    editor_only_render_when_focused = true,
  },
}
