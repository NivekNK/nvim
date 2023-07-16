local keymaps = require("config.keymaps").color
local M = {}

M.ccc = function(mapping)
    return {
        default_color = "#000000",
        point_char = "◊",
        point_color = "",
        bar_len = 30,
        win_opts = {
            relative = "cursor",
            row = 1,
            col = 1,
            style = "minimal",
            border = "rounded",
        },
        auto_close = true,
        preserve = false,
        save_on_quit = true,
        alpha_show = "auto",
        highlight_mode = "bg",
        highlighter = {
            auto_enable = true,
            filetypes = {},
            excludes = {},
            lsp = true,
        },
        recognize = {
            input = true,
            output = true,
        },
        mappings = {
            [keymaps.close] = mapping.quit,
            [keymaps.accept] = mapping.complete,
            [keymaps.toggle_alpha] = mapping.toggle_alpha,
            [keymaps.increase] = mapping.increase1,
            [keymaps.big_increase] = mapping.increase5,
            [keymaps.decrease] = mapping.decrease1,
            [keymaps.big_decrease] = mapping.decrease5,
            [keymaps.set_to_zero] = mapping.set0,
            [keymaps.set_to_max] = mapping.set100,
            [keymaps.toggle_output_mode] = mapping.toggle_output_mode,
            [keymaps.toggle_input_mode] = mapping.toggle_input_mode,
        },
    }
end

M.colortils = {
    -- Register in which color codes will be copied
    register = "+",
    -- Preview for colors, if it contains `%s` this will be replaced with a hex color code of the color
    color_preview = "█ %s",
    -- The default in which colors should be saved
    -- This can be hex, hsl or rgb
    default_format = "hex",
    -- Border for the float
    border = "rounded",
    -- Some mappings which are used inside the tools
    mappings = {
        -- increment values
        increment = keymaps.increase,
        -- decrement values
        decrement = keymaps.decrease,
        -- increment values with bigger steps
        increment_big = keymaps.big_increase,
        -- decrement values with bigger steps
        decrement_big = keymaps.big_decrease,
        -- set values to the minimum
        min_value = keymaps.set_to_zero,
        -- set values to the maximum
        max_value = keymaps.set_to_max,
        -- save the current color in the register specified above with the format specified above
        set_register_default_format = "r<CR>", -- should not use
        -- save the current color in the register specified above with a format you can choose
        set_register_cjoose_format = "rf<CR>", -- should not use
        -- replace the color under the cursor with the current color in the format specified above
        replace_default_format = "f<CR>",      -- should not use
        -- replace the color under the cursor with the current color in a format you can choose
        replace_choose_format = keymaps.accept,
        -- export the current color to a different tool
        export = "E",    -- should not use
        -- set the value to a certain number (done by just entering numbers)
        set_value = "c", -- should not use
        -- toggle transparency
        transparency = keymaps.toggle_alpha,
        -- choose the background (for transparent colors)
        choose_background = "B", -- should not use
    },
}

return M
