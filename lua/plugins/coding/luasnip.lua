return {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local ls = require("luasnip")
        local types = require("luasnip.util.types")

        ls.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "●", "GruvboxOrange" } },
                    },
                },
            },
        })

        -- 加载友好片段
        require("luasnip.loaders.from_vscode").lazy_load()

        -- 快捷键映射
        vim.keymap.set({"i", "s"}, "<C-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({"i", "s"}, "<C-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        vim.keymap.set("i", "<C-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end)
    end,
}
