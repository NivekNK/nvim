local Utils = require("user.utils")
local keymaps = require("config.keymaps")

local mini_move_config = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = keymaps.mini_move,
    -- Options which control moving behavior
    options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
    },
}

return {
    {
        "echasnovski/mini.move",
        version = "*",
        config = function()
            Utils.callback_if_ok_msg("mini.move", function(mini_move)
                mini_move.setup(mini_move_config)
            end)
        end
    }
}
