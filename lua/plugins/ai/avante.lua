return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    config = function()
        local endpoint = tostring(os.getenv("AVANTE_API_ENDPOINT"))
        local model    = tostring(os.getenv("AVANTE_MODEL_NAME"))

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
                return hub and hub:get_active_servers_prompt() or ""
            end,
            -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
            custom_tools = function()
                return {
                    require("mcphub.extensions.avante").mcp_tool(),
                }
            end,
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- 以下依赖项是可选的，
        "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
        "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
        "hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
        "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
        "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- 用于 providers='copilot'
        {
            -- 支持图像粘贴
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- 推荐设置
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- Windows 用户必需
                    use_absolute_path = true,
                },
            },
        },
        {
            -- 如果您有 lazy=true，请确保正确设置
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
