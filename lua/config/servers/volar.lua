return {
    lang = "vue",
    opts = {
        cmd = { "vue-language-server", "--stdio" },
        filetypes = { "vue" },
        root_dir = require("user.utils").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    },
}
