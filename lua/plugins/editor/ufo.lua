return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'nvim-treesitter/nvim-treesitter',
    },
    event = "VeryLazy",
    config = function()
        local ftMap = {
            vim = 'indent',
            python = 'indent',
            git = '',
            lua = 'indent',
        }

        require('ufo').setup({
            open_fold_hl_timeout = 150,
            close_fold_kinds_for_ft = {
                default = {'imports', 'comment'},
                json = {'array'},
                c = {'comment', 'region'},
                lua = { 'comment' },
            },
            preview = {
                win_config = {
                    border = {'', '─', '', '', '', '─', '', ''},
                    winhighlight = 'Normal:Folded',
                    winblend = 0
                },
                mappings = {
                    scrollU = '<C-u>',
                    scrollD = '<C-d>',
                    jumpTop = '[',
                    jumpBot = ']'
                }
            },
            provider_selector = function(bufnr, filetype, buftype)
                return ftMap[filetype] or 'indent'
            end
        })

        -- 键位映射
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
        vim.keymap.set('n', 'zK', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, { desc = 'Peek folded lines under cursor' })
    end,
}
