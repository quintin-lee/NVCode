return {
    'ZhiyuanLck/smart-pairs',
    event = 'InsertEnter',
    config = function()
        require('pairs'):setup({
            enter = {
                enable_mapping = true,
                enable_fallback = true,
                enable_check = true,
            },
            space = {
                enable_mapping = true,
                enable_fallback = true,
                enable_check = true,
            },
            disable_filetype = { "TelescopePrompt" },
            disable_when_touch = false,
        })
    end,
}
