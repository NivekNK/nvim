local Utils = require("user.utils")
local keymaps = require("config.keymaps").harpoon

local harpoon_config = {
    ---@type HarpoonSettings
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = false,
        key = function()
            return vim.loop.cwd() or ""
        end
    }
}

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        Utils.callback_if_ok_msg("harpoon", function(harpoon)
            harpoon:setup(harpoon_config)

            harpoon:extend({
                UI_CREATE = function(cx)
                    vim.keymap.set("n", keymaps.open_vertical_split, function()
                        harpoon.ui:select_menu_item({ vsplit = true })
                    end, { buffer = cx.bufnr })

                    vim.keymap.set("n", keymaps.open_horizontal_split, function()
                        harpoon.ui:select_menu_item({ split = true })
                    end, { buffer = cx.bufnr })
                end
            })

            require("plugins.harpoon.telescope")
        end)
    end
}
