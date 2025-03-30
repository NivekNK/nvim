local icons = require("config.icons")

local diagnostic = {
    virtual_text = true, -- enable/disable virtual text
    signs_icons = {
        error = icons.error .. " ",
        warning = icons.warning .. " ",
        info = icons.info .. " ",
        hint = icons.hint,
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
