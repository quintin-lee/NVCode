return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    config = function()
        local endpoint = tostring(os.getenv("AVANTE_API_ENDPOINT"))
        local model    = tostring(os.getenv("AVANTE_MODEL_NAME"))
        local api_key  = tostring(os.getenv("AVANTE_API_KEY"))

        require('avante').setup({
        provider = "ollama",
        mappings = {
            ask = "na", -- ask
            edit = "ne", -- edit
            refresh = "nr", -- refresh
        },
        vendors = {
            ollama = {
                __inherited_from = "openai",
                api_key_name = "AVANTE_API_KEY",
                endpoint = endpoint,
                model = model,
            },
        }
        })
    end,
}
