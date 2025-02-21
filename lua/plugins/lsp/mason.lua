return {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    config = function()
        -- vim.notify("Configuring Mason", vim.log.levels.INFO)  -- 使用 vim.notify
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })
    end,
}
