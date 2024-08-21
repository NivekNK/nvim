local icons = require("config.icons")
local Utils = require("user.utils")

local gitsigns_config = {
    signs = {
        add = {
            text = icons.gitsigns.change,
        },
        change = {
            text = icons.gitsigns.change,
        },
        delete = {
            text = icons.gitsigns.deleted,
        },
        topdelete = {
            text = icons.gitsigns.deleted,
        },
        changedelete = {
            text = icons.gitsigns.change,
        },
        untracked = {
            text = icons.gitsigns.change,
        },
    },
    signs_staged = {
        add = {
            text = icons.gitsigns.change,
        },
        change = {
            text = icons.gitsigns.change,
        },
        delete = {
            text = icons.gitsigns.deleted,
        },
        topdelete = {
            text = icons.gitsigns.deleted,
        },
        changedelete = {
            text = icons.gitsigns.change,
        },
        untracked = {
            text = icons.gitsigns.change,
        },
    },
    signs_staged_enable = true,
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
}

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            Utils.callback_if_ok_msg("gitsigns", function(gitsigns)
                gitsigns.setup(gitsigns_config)
            end)
        end,
    },
}
