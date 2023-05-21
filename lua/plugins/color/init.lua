local keymaps = require("config.keymaps").color

local function get_ccc_config(mapping)
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

local colortils_config = {
    -- Register in which color codes will be copied
    register = "+",
    -- Preview for colors, if it contains `%s` this will be replaced with a hex color code of the color
    color_preview =  "█ %s",
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
        replace_default_format = "f<CR>", -- should not use
        -- replace the color under the cursor with the current color in a format you can choose
        replace_choose_format = keymaps.accept,
        -- export the current color to a different tool
        export = "E", -- should not use
        -- set the value to a certain number (done by just entering numbers)
        set_value = "c", -- should not use
        -- toggle transparency
        transparency = keymaps.toggle_alpha,
        -- choose the background (for transparent colors)
        choose_background = "B", -- should not use
    },
}

return {
    {
        "uga-rosa/ccc.nvim",
        event = "BufEnter",
        config = function()
            local ccc_ok, ccc = pcall(require, "ccc")
            if not ccc_ok then
                vim.notify("[color] Error loading ccc!", vim.log.levels.ERROR)
                return
            end

            -- HACK: The default format doesn't use comma's for rgb or rgba
            require("ccc.output.css_rgb").str = function(RGB, A)
                local utils = require("ccc.utils")
                local convert = require("ccc.utils.convert")

                local R, G, B = convert.rgb_format(RGB)
                R = utils.round(R)
                G = utils.round(G)
                B = utils.round(B)
                if A then
                    A = utils.round(A * 255)
                    return ("rgba(%d, %d, %d, %d)"):format(R, G, B, A)
                else
                    return ("rgb(%d, %d, %d)"):format(R, G, B)
                end
            end

            local config = get_ccc_config(ccc.mapping)
            local default_mappings = {
                ["q"] = ccc.mapping.none,
                ["<CR>"] = ccc.mapping.none,
                ["i"] = ccc.mapping.none,
                ["o"] = ccc.mapping.none,
                ["r"] = ccc.mapping.none,
                ["a"] = ccc.mapping.none,
                ["g"] = ccc.mapping.none,
                ["w"] = ccc.mapping.none,
                ["b"] = ccc.mapping.none,
                ["W"] = ccc.mapping.none,
                ["B"] = ccc.mapping.none,
                ["l"] = ccc.mapping.none,
                ["d"] = ccc.mapping.none,
                [","] = ccc.mapping.none,
                ["h"] = ccc.mapping.none,
                ["s"] = ccc.mapping.none,
                ["m"] = ccc.mapping.none,
                ["H"] = ccc.mapping.none,
                ["M"] = ccc.mapping.none,
                ["L"] = ccc.mapping.none,
                ["0"] = ccc.mapping.none,
            }
            config.mappings = vim.tbl_deep_extend("force", default_mappings, config.mappings)
            for i = 1, 100 do
                config.mappings[string.format("%d", i)] = function()
                    ccc.set_percent(i)
                end
            end

            -- config["convert"] = {
            --     { ccc.picker.hex,     fix_rgb },
            --     { fix_rgb, ccc.output.css_hsl },
            -- }

            ccc.setup(config)
        end,
    },
    {
        "nvim-colortils/colortils.nvim",
        event = "BufEnter",
        config = function()
            local colortils_ok, colortils = pcall(require, "colortils")
            if not colortils_ok then
                vim.notify("[color] Error loading colortils!", vim.log.levels.ERROR)
                return
            end
            colortils.setup(colortils_config)
        end,
    },
}
