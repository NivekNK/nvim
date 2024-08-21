local Utils = require("user.utils")

local function get_vue_typescript_plugin_path()
    local npm_global_path = Utils.get_npm_global_directory()
    if npm_global_path then
        return Utils.path_combine(npm_global_path, "/@vue/typescript-plugin")
    else
        Utils.notify_error("tsserver >> npm not installed!")
        return ""
    end
end

return {
    lang = {
        "javascript",
        "typescript",
        "vue",
    },
    opts = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
        },
        init_options = {
            hostInfo = "neovim",
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = get_vue_typescript_plugin_path(),
                    languages = { "javascript", "typescript", "vue" },
                },
            },
        },
        root_dir = Utils.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        single_file_support = true,
    },
}
