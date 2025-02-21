return {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
    },
    config = function()
        -- vim.notify("Configuring nvim-cmp", vim.log.levels.INFO)
        local luasnip = require('luasnip')
        -- nvim-cmp setup
        local cmp = require('cmp')
        local core = require('cmp.core')
        local keymap = require('cmp.utils.keymap')

        -- Automagically formatting on save
        vim.cmd [[autocmd BufWritePre *.c,*.cpp,*.C,*.cc,*.c++,*.cxx,*.h,*.hxx,*.hpp,*.cu lua vim.lsp.buf.format()]]

        local cmp_kinds = {
            Text = '  ',
            Method = '  ',
            Function = '  ',
            Constructor = '  ',
            Field = '  ',
            Variable = '  ',
            Class = '  ',
            Interface = '  ',
            Module = '  ',
            Property = '  ',
            Unit = '  ',
            Value = '  ',
            Enum = '  ',
            Keyword = '  ',
            Snippet = '  ',
            Color = '  ',
            File = '  ',
            Reference = '  ',
            Folder = '  ',
            EnumMember = '  ',
            Constant = '  ',
            Struct = '  ',
            Event = '  ',
            Operator = '  ',
            TypeParameter = '  ',
          }

          cmp.setup {
              enabled = function()
                -- disable completion in comments
                local context = require 'cmp.config.context'
                -- keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == 'c' then
                  return true
                else
                  return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
                end
              end,
              completion = {
                  autocomplete = false,
                  --autocomplete = {
                  --    cmp.TriggerEvent.TextChanged,
                  --    -- cmp.TriggerEvent.InsertEnter,
                  --},
                  completeopt = "menuone,noinsert,noselect",
                  keyword_length = 2,
              },
              preselect = cmp.PreselectMode.None,
              snippet = {
                  expand = function(args)
                      luasnip.lsp_expand(args.body)
                  end,
              },
              windows = {
                  completion = cmp.config.window.bordered(),
                  documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<CR>'] = cmp.mapping.confirm {
                      --behavior = cmp.ConfirmBehavior.Replace,
                      select = true,
                  },
                  ['<Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                          cmp.select_next_item()
                      elseif luasnip.expand_or_jumpable() then
                          luasnip.expand_or_jump()
                      else
                          fallback()
                      end
                  end, { 'i', 's' }),
                  ['<S-Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                          cmp.select_prev_item()
                      elseif luasnip.jumpable(-1) then
                          luasnip.jump(-1)
                      else
                          fallback()
                      end
                  end, { 'i', 's' }),
              }),
              sources = {
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'doxygen' },
              },
              formatting = {
                  format = function(_, vim_item)
                      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
                      return vim_item
                  end,
              },
              confirm = function(option)
                  option = option or {}
                  local e = core.menu:get_selected_entry() or (option.select and core.menu:get_first_entry() or nil)
                  -- vim.notify('confirm', vim.log.levels.INFO)
                  if e then
                      core.confirm(e, {
                          behavior = option.behavior,
                      }, function()
                          local myContext  =	core.get_context({ reason = cmp.ContextReason.TriggerOnly })
                          core.complete(myContext)
                          --function() 自动增加()
                          if e and e.resolved_completion_item and (e.resolved_completion_item.kind==3 or e.resolved_completion_item.kind==2) then
                              vim.api.nvim_feedkeys(keymap.t('()<Left>'), 'n', true)
                          end
                      end)
                      return true
                  else
                      return false
                  end
              end,

              -- define the appearance of the completion menu
              window = {
                  completion = cmp.config.window.bordered({
                      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                  }),
                  documentation = cmp.config.window.bordered({
                      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                  }),
              },
          }

          cmp.setup.cmdline(':', {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                  { name = 'path' }
              }, {
                  {
                      name = 'cmdline',
                      option = {
                          ignore_cmds = { 'Man', '!' }
                      }
                  }
              })
          })

          vim.api.nvim_create_autocmd(
              {"TextChangedI", "TextChangedP"},
              {
                  callback = function()
                      local line = vim.api.nvim_get_current_line()
                      local cursor = vim.api.nvim_win_get_cursor(0)[2]

                      local current = string.sub(line, cursor, cursor + 1)
                      if cursor == 0 or current == "," or current == " " or current == "/" or current == "*"
                          or current == ";" or current == ":" or current == "{" or current == ")" or current == "}" or current == "]" then
                          require('cmp').close()
                          return
                      end

                      local before_line = string.sub(line, 1, cursor + 1)
                      local after_line = string.sub(line, cursor + 1, -1)
                      if not string.match(before_line, '^%s+$') then
                          if after_line == "" or after_line == ";" or after_line == "}" or after_line == ")" or after_line == "]"
                              or string.match(before_line, " $") or string.match(before_line, "%.$") then
                              require('cmp').complete()
                          end
                      end
                  end,
                  --pattern = "*"
              }
          )
    end,
}
