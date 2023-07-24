return {
    lang = "lua",
    opts = {
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                        "${3rd}/luv/library",
                    },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
}
