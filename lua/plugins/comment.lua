local keymaps = require("config.keymaps").comment
local comment_config = {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = keymaps.toggler,
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = keymaps.opleader,
    ---LHS of extra mappings
    extra = keymaps.extra,
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won"t create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true
    },
    ---Function to call before (un)comment
    pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if vim.bo.filetype == "typescriptreact" then
            local U = require("Comment.utils")

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
                location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring({
                key = type,
                location = location
            })
        end
    end,    ---Function to call after (un)comment
    post_hook = nil
}

return {
    "numToStr/Comment.nvim",
    event = "BufRead",
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            event = "VeryLazy"
        }
    },
    config = function()
        local comment_ok, comment = pcall(require, "Comment")
        if not comment_ok then
            vim.notify("Error loading Comment!", vim.log.levels.ERROR)
            return
        end
        comment.setup(comment_config)
    end
}
