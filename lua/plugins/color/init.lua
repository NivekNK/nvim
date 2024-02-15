local keymaps = require("config.keymaps").color
local Utils = require("user.utils")

-- TODO: Clone this plugin and change output functionality
-- TODO: Make a tailwind extension.
local function get_ccc_config(mapping, builtin, custom)
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
        disable_default_mappings = true,
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
        recognize = {
            input = true,
            output = true,
        },
        inputs = {
            builtin.input.rgb,
            custom.input.NKHslInput,
            builtin.input.hsl,
            builtin.input.cmyk,
        },
        outputs = {
            builtin.output.hex,
            builtin.output.hex_short,
            builtin.output.css_rgb,
            custom.output.NKHslOutput,
            builtin.output.css_hsl,
        },
        pickers = {
            builtin.picker.hex,
            builtin.picker.css_rgb,
            custom.picker.NKHslPicker,
            builtin.picker.css_hsl,
            builtin.picker.css_hwb,
            builtin.picker.css_lab,
            builtin.picker.css_lch,
            builtin.picker.css_oklab,
            builtin.picker.css_oklch,
        },
    }
end

return {
    {
        "uga-rosa/ccc.nvim",
        event = "BufEnter",
        config = function()
            Utils.callback_if_ok_msg("ccc", function(ccc)
                local config = get_ccc_config(ccc.mapping, {
                    input = ccc.input,
                    output = ccc.output,
                    picker = ccc.picker,
                }, {
                    input = require("plugins.color.input"),
                    output = require("plugins.color.output"),
                    picker = require("plugins.color.picker"),
                })

                for i = 1, 100 do
                    config.mappings[string.format("%d", i)] = function()
                        ccc.set_percent(i)
                    end
                end

                ccc.setup(config)
            end)
        end,
    },
}
