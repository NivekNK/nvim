local Utils = require("user.utils")

local hlslens_config = {
    -- Enable nvim-hlslens automatically
    auto_enable        = true,
    -- When `incsearch` option is on and enable_incsearch is true, add lens
    -- for the current matched instance
    enable_incsearch   = true,
    -- If calm_down is true, clear all lens and highlighting When the cursor is
    -- out of the position range of the matched instance or any texts are changed
    calm_down          = false,
    -- Only add lens for the nearest matched instance and ignore others
    nearest_only       = true,
    -- When to open the floating window for the nearest lens.
    --     'auto': floating window will be opened if room isn't enough for virtual text;
    --     'always': always use floating window instead of virtual text;
    --     'never': never use floating window for the nearest lens
    nearest_float_when = "auto",
    -- Winblend of the nearest floating window. `:h winbl` for more details
    float_shadow_blend = 50,
    -- Priority of virtual text, set it lower to overlay others.
    -- `:h nvim_buf_set_extmark` for more details
    virt_priority      = 100,
    -- Hackable function for customizing the lens. If you like hacking, you
    -- should search `override_lens` and inspect the corresponding source code.
    -- There's no guarantee that this function will not be changed in the future. If it is
    -- changed, it will be listed in the CHANGES file.
    --     @param render table an inner module for hlslens, use `setVirt` to set virtual text
    --     @param splist table (1,1)-indexed position
    --     @param nearest boolean whether nearest lens
    --     @param idx number nearest index in the plist
    --     @param relIdx number relative index, negative means before current position, positive means after
    override_lens = nil,
    build_position_cb  = function(plist, _, _, _)
        if Utils.require_check("scrollbar") then
            require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end
    end,
}

return {
    "kevinhwang91/nvim-hlslens",
    event = "BufEnter",
    config = function()
        Utils.callback_if_ok_msg("hlslens", function(hlslens)
            hlslens.setup(hlslens_config)

            if Utils.require_check("scrollbar") then
                vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
                    pattern = { "*" },
                    callback = function(_)
                        require("scrollbar.handlers.search").handler.hide()
                    end,
                })
            end
        end)
    end,
}
