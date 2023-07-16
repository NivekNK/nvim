local Utils = require("user.utils")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local function get_config(formatting, diagnostics)
    return {
        border = "rounded",
        cmd = { "nvim" },
        debounce = 250,
        debug = false,
        default_timeout = 5000,
        diagnostic_config = nil,
        diagnostics_format = "#{m}",
        fallback_severity = vim.diagnostic.severity.ERROR,
        log_level = "warn",
        notify_format = "[null-ls] %s",
        on_attach = nil,
        on_init = nil,
        on_exit = nil,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
        should_attach = nil,
        sources = {},
        temp_dir = nil,
        update_in_insert = false,
    }
end

return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        Utils.callback_if_ok_msg("null-ls", function(null_ls)
            local config = get_config(null_ls.builtins.formatting, null_ls.builtins.diagnostics)
            null_ls.setup(config)
        end)
    end,
}
