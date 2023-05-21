local function get_ccc_config(mapping)
local keymaps = require("config.keymaps").color
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
        [keymaps.increase_by_1] = mapping.increase1,
        [keymaps.increase_by_5] = mapping.increase5,
        [keymaps.decrease_by_1] = mapping.decrease1,
        [keymaps.decrease_by_5] = mapping.decrease5,
        [keymaps.set_to_zero] = mapping.set0,
        [keymaps.set_to_max] = mapping.set100,
        [keymaps.toggle_output_mode] = mapping.toggle_output_mode,
        [keymaps.toggle_input_mode] = mapping.toggle_input_mode,
    },
}
end

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
            ccc.setup(config)
        end,
    },
}
