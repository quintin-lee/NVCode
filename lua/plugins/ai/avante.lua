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
            },
            -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
            system_prompt = function()
                local hub = require("mcphub").get_hub_instance()
                return hub:get_active_servers_prompt()
            end,
            -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
            custom_tools = function()
                return {
                    require("mcphub.extensions.avante").mcp_tool(),
                }
            end,
        })
    end,
}
