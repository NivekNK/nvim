local Utils = require("nk.utils")
local Clue = require("nk.mini-clue")

local mini_clue_config = {
    -- Array of extra clues to show
    clues = {},

    -- Array of opt-in triggers which start custom key query process.
    -- **Needs to have something in order to show clues**.
    triggers = {
        { mode = "n", keys = "<leader>" },
        { mode = "x", keys = "<leader>" },
    },

    -- Clue window settings
    window = {
        -- Floating window config
        config = {},

        -- Delay before showing clue window
        delay = 300,

        -- Keys to scroll inside the clue window
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
    },
}

return {
    "echasnovski/mini.clue",
    version = "*",
    config = function()
        local ok, miniclue = pcall(require, "mini.clue")
        if not ok then
            Utils.notify_error("Failed to load mini.clue.")
            return
        end

        Utils.foreach_filename("/config/mini-clue", function(plugin)
            plugin = "config.mini-clue." .. plugin
            ok, _ = pcall(require, plugin)
            if not ok then
                Utils.notify_error("Failed to load [" .. plugin .. "] mini-clue.")
            end
        end)

        Clue:apply()

        mini_clue_config.clues = vim.list_extend(mini_clue_config.clues, Clue.groups)
        miniclue.setup(mini_clue_config)
    end,
    dependencies = {
        {
            "echasnovski/mini.nvim",
            version = "*",
        },
    }
}
