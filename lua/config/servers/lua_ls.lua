return {
    lang = "lua",
    opts = {
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
                    }
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    formatter = function(formatters, _)
        return {
            formatters.stylua,
        }
    end
}
