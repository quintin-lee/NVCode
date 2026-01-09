return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		-- vim.notify("Configuring nvim-cmp", vim.log.levels.INFO)
		local luasnip = require("luasnip")
		-- nvim-cmp setup
		local cmp = require("cmp")
		local core = require("cmp.core")
		local keymap = require("cmp.utils.keymap")

		local cmp_kinds = {
			Text = "  ",
			Method = "  ",
			Function = "  ",
			Constructor = "  ",
			Field = "  ",
			Variable = "  ",
			Class = "  ",
			Interface = "  ",
			Module = "  ",
			Property = "  ",
			Unit = "  ",
			Value = "  ",
			Enum = "  ",
			Keyword = "  ",
			Snippet = "  ",
			Color = "  ",
			File = "  ",
			Reference = "  ",
			Folder = "  ",
			EnumMember = "  ",
			Constant = "  ",
			Struct = "  ",
			Event = "  ",
			Operator = "  ",
			TypeParameter = "  ",
		}

		cmp.setup({
			enabled = function()
				-- disable completion in comments
				local context = require("cmp.config.context")
				-- keep command mode completion enabled when cursor is in a comment
				if vim.api.nvim_get_mode().mode == "c" then
					return true
				else
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end
			end,
			completion = {
				autocomplete = false,
				completeopt = "menuone,noinsert,noselect",
				keyword_length = 2, -- Reduced to improve responsiveness while maintaining accuracy
				get_trigger_characters = function(trigger_characters)
					-- Only return trigger characters when LSP provides them
					return trigger_characters
				end,
			},
			preselect = cmp.PreselectMode.None,
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					-- Set max height to prevent large popups that affect performance
					max_height = 12,
					-- Reduce scrolling for better performance
					scrollbar = false,
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					-- Set max width/height to limit resource usage
					max_width = 60,
					max_height = 15,
				}),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				-- Only confirm explicitly; avoid accepting by accidental Enter
				["<CR>"] = cmp.mapping.confirm({
					select = false,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", group_index = 1 },
				{ name = "luasnip", group_index = 2 },
				{ name = "doxygen", group_index = 3 },
			}, {
				{ name = "buffer", group_index = 4 },
				{ name = "path", group_index = 5 },
			}),
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(entry, vim_item)
					vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
						doxygen = "[Doxygen]",
					})[entry.source.name]
					return vim_item
				end,
			},
			confirm = function(option)
				option = option or {}
				local e = core.menu:get_selected_entry() or (option.select and core.menu:get_first_entry() or nil)
				if e then
					core.confirm(e, {
						behavior = option.behavior,
					}, function()
						local myContext = core.get_context({ reason = cmp.ContextReason.TriggerOnly })
						core.complete(myContext)
						if
							e
							and e.resolved_completion_item
							and (e.resolved_completion_item.kind == 3 or e.resolved_completion_item.kind == 2)
						then
							vim.api.nvim_feedkeys(keymap.t("()<Left>"), "n", true)
						end
					end)
					return true
				else
					return false
				end
			end,
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		-- Optimized auto-trigger to reduce performance overhead
		local check_backspace = function()
			local col = vim.fn.col(".") - 1
			return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
		end

		vim.api.nvim_create_autocmd({ "TextChangedI" }, {
			callback = function()
				-- Prevent triggering in comments or strings
				local context = require("cmp.config.context")
				if context.in_treesitter_capture("comment") or context.in_treesitter_capture("string") then
					require("cmp").close()
					return
				end

				-- Check if we have typed something meaningful after a trigger character
				local line = vim.api.nvim_get_current_line()
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local before = string.sub(line, 1, col)

				-- Check for trigger characters
				local has_trigger = string.match(before, "%.$")
					or string.match(before, "%->$")
					or string.match(before, "::%s*$")
					or string.match(before, ":%:$")

				-- Check for word completion
				local word = before:match("[%w_][%w_%p]-$") or before:match("[%w_]+$") or ""
				local should_trigger = has_trigger or (#word >= 2 and not check_backspace())

				if should_trigger then
					vim.defer_fn(function()
						if
							vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
							and require("cmp").visible() == false
						then
							require("cmp").complete()
						end
					end, 100) -- Small delay to prevent excessive triggering
				end
			end,
		})
	end,
}
