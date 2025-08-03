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
            provider = "openrouter",
            mappings = {
                ask = "na", -- ask
                edit = "ne", -- edit
                refresh = "nr", -- refresh
            },
            -- vendors = {
            providers = {
                openrouter = {
                    __inherited_from = "openai",
                    api_key_name = "AVANTE_API_KEY",
                    endpoint = endpoint,
                    model = model,
                    -- max_tokens = 4096,
                    use_xml_format = false,
                    extra_request_body = {
                        max_tokens = 4096,
                        temperature = 0.7,
                    },
                },
            }
        })
    end,
}
