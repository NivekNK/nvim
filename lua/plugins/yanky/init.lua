local function get_yanky_config(keymaps, mapping, utils)
return {
    ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
    },
    picker = {
        select = {
            action = nil, -- nil to use default put action
        },
        telescope = {
            mappings = {
                default = mapping.put("p"),
                i = {
                    [keymaps.i.paste_after] = mapping.put("p"),
                    [keymaps.i.paste_before] = mapping.put("P"),
                    [keymaps.i.delete] = mapping.delete(),
                    [keymaps.i.register] = mapping.set_register(utils.get_default_register()),
                },
                n = {
                    [keymaps.n.paste_after] = mapping.put("p"),
                    [keymaps.n.paste_before] = mapping.put("P"),
                    [keymaps.n.delete] = mapping.delete(),
                    [keymaps.n.register] = mapping.set_register(utils.get_default_register()),
                },
            }, -- nil to use default mappings
        },
    },
    system_clipboard = {
        sync_with_ring = true,
    },
    highlight = {
        on_put = false,
        on_yank = true,
        timer = 500,
    },
    preserve_cursor_position = {
        enabled = true,
    },
}
end

return {
    "gbprod/yanky.nvim",
    event = "WinEnter",
    config = function()
        local yanky_ok, yanky = pcall(require, "yanky")
        if not yanky_ok then
            vim.notify("Error loading yanky!", vim.log.levels.ERROR)
            return
        end

        -- Create the command "NKForceVisualMode"
        vim.api.nvim_create_user_command("YankyForceVisualMode", function()
            local mode = vim.api.nvim_get_mode().mode
            if mode ~= "v" and mode ~= "V" then
                vim.cmd("normal! v")
            end
        end, { desc = "Force to be on visual mode for Yanky." })

        local keymaps = require("config.keymaps").yanky
        local config = get_yanky_config(keymaps.telescope, require("yanky.telescope.mapping"), require("yanky.utils"))
        yanky.setup(config)

        vim.keymap.set({ "n","x" }, "y", "<Plug>(YankyYank)")
        vim.keymap.set({ "n","x" }, "p", '<cmd>YankyForceVisualMode<CR>"_d<Plug>(YankyPutBefore)')
        vim.keymap.set({ "n","x" }, "P", '<cmd>YankyForceVisualMode<CR>"_d<Plug>(YankyPutAfter)')
        vim.keymap.set({ "n","x" }, "gp", '<Plug>(YankyGPutAfter)')
        vim.keymap.set({ "n","x" }, "gP", '<Plug>(YankyGPutBefore)')

        vim.keymap.set("n", keymaps.paste_indent_right_after, '<Plug>(YankyPutIndentAfterShiftRight)')
        vim.keymap.set("n", keymaps.paste_indent_left_after, '<Plug>(YankyPutIndentAfterShiftLeft)')
        vim.keymap.set("n", keymaps.paste_at_indent_after, '<Plug>(YankyPutAfterFilter)')
        vim.keymap.set("n", keymaps.paste_indent_right_before, '<Plug>(YankyPutIndentBeforeShiftRight)')
        vim.keymap.set("n", keymaps.paste_indent_left_before, '<Plug>(YankyPutIndentBeforeShiftLeft)')
        vim.keymap.set("n", keymaps.paste_at_indent_before, '<Plug>(YankyPutBeforeFilter)')

        local telescope_ok, telescope = pcall(require, "telescope")
        if telescope_ok then
            telescope.load_extension("yank_history")
        end
    end,
}
