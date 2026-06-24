return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    enabled = true,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 100,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author> • <author_time:%Y-%m-%d> • <summary>",
      update_debounce = 100,
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        -- ============ 导航 ============
        -- ]h / [h — 跳转到下一个/上一个 hunk
        vim.keymap.set("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]h", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { buffer = bufnr, desc = "Next Hunk" })

        vim.keymap.set("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[h", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { buffer = bufnr, desc = "Prev Hunk" })

        -- ============ Hunk 操作 ============
        vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        vim.keymap.set("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Stage selected hunk" })
        vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        vim.keymap.set("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Reset selected hunk" })
        vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
        vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })

        -- ============ Blame ============
        vim.keymap.set("n", "<leader>hb", function()
          gitsigns.blame_line({ full = false })
        end, { buffer = bufnr, desc = "Blame line (popup)" })
        vim.keymap.set("n", "<leader>hB", gitsigns.blame, { buffer = bufnr, desc = "Blame buffer" })
        vim.keymap.set("n", "<leader>htb", gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })

        -- ============ Diff ============
        vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr, desc = "Diff this" })
        vim.keymap.set("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { buffer = bufnr, desc = "Diff this (index)" })

        -- ============ Toggle 开关 ============
        vim.keymap.set("n", "<leader>hts", gitsigns.toggle_signs, { buffer = bufnr, desc = "Toggle signs" })
        vim.keymap.set("n", "<leader>htn", gitsigns.toggle_numhl, { buffer = bufnr, desc = "Toggle line number hl" })
        vim.keymap.set("n", "<leader>htw", gitsigns.toggle_word_diff, { buffer = bufnr, desc = "Toggle word diff" })
      end,
    },
  },
}
