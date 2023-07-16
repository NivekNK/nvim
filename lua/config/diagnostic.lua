local icons = require("config.icons")

local diagnostic = {
    virtual_text = true, -- enable/disable virtual text
    signs = {
        active = {
	    { name = "DiagnosticSignError", text = icons.error .. " " },
	    { name = "DiagnosticSignWarn", text = icons.warning .. " " },
	    { name = "DiagnosticSignInfo", text = icons.info .. " " },
	    { name = "DiagnosticSignHint", text = icons.hint },
	}
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

return diagnostic
