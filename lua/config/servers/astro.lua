return {
    lang = "astro",
    opts = function()
        vim.filetype.add({
            extension = {
                astro = "astro"
            }
        })

        return {
            cmd = { "astro-ls", "--stdio" },
            filetypes = { "astro" },
            init_options = {
                typescript = {},
            },
            root_dir = require("user.utils").root_pattern(
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                ".git"
            ),
        }
    end,
}
