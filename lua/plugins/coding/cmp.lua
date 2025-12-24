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
				keyword_length = 3, -- increase minimum length to reduce accidental triggers
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
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "doxygen" },
			},
			formatting = {
				format = function(_, vim_item)
					vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
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

			-- define the appearance of the completion menu
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				}),
			},
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

		-- 更加稳健的自动触发：防抖 + 明确触发字符或词长阈值 + 忽略注释/字符串
		do
			local debounce_timers = {}
			local DEBOUNCE_MS = 150

			vim.api.nvim_create_autocmd({ "TextChangedI" }, {
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()

					-- 取消已存在的计时器
					if debounce_timers[bufnr] then
						pcall(function()
							debounce_timers[bufnr]:stop()
							debounce_timers[bufnr]:close()
						end)
						debounce_timers[bufnr] = nil
					end

					local timer = vim.loop.new_timer()
					timer:start(
						DEBOUNCE_MS,
						0,
						vim.schedule_wrap(function()
							debounce_timers[bufnr] = nil

							local context = require("cmp.config.context")
							-- 在注释或字符串中不触发
							if context.in_treesitter_capture("comment") or context.in_treesitter_capture("string") then
								require("cmp").close()
								return
							end

							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local before = string.sub(line, 1, col)

							-- 明确触发字符（支持多字符触发，如 :: 和 ->）
							local trigger_patterns = { "%.$", ">%>", ":%:$", "%->$", "::%s*$" }
							-- 更稳妥的逐项检查（也检查常见的单字符触发）
							local should_trigger = false

							if
								string.match(before, "%.$")
								or string.match(before, "%->$")
								or string.match(before, "::%s*$")
								or string.match(before, ":%:$")
							then
								should_trigger = true
							end

							-- 如果单词长度超过阈值也触发
							local word = before:match("[%w_]+$") or ""
							if #word >= 3 then
								should_trigger = true
							end

							if should_trigger then
								require("cmp").complete()
							else
								require("cmp").close()
							end
						end)
					)

					debounce_timers[bufnr] = timer
				end,
			})
		end
	end,
}
