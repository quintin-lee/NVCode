require("translate").setup({
    default = {
        command = "translate_shell",
        output = "floating",
        parser_before = "trino",
        parser_after = "window",
    },
    preset = {
        output = {
            split = {
                append = true,
            },
        },
    },
})
