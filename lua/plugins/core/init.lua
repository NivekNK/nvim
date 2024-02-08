local Utils = require("user.utils")

return {
    "nvim-lua/plenary.nvim",
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd([[ colorscheme tokyonight-moon ]])
    --     end,
    -- },
    {
        "NivekNK/nk-theme.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nk-theme")
        end
    },
    {
        -- https://github.com/mg979/vim-visual-multi
        -- select words with Ctrl-N (like Ctrl-d in Sublime Text/VS Code)
        -- create cursors vertically with Ctrl-Down/Ctrl-Up
        -- select one character at a time with Shift-Arrows
        -- press n/N to get next/previous occurrence
        -- press [/] to select next/previous cursor
        -- press q to skip current and get next occurrence
        -- press Q to remove current cursor/selection
        -- start insert mode with i,a,I,A
        "mg979/vim-visual-multi",
        event = "BufEnter",
    },
    "nicwest/vim-camelsnek",
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        -- Initiate the search in the forward (s) or backward (S) direction, or in the other windows (gs).
        -- Start typing a 2-character pattern ({c1}{c2}).
        -- After typing the first character, you see "labels" appearing next to some of the {c1}{?} pairs. You cannot use the labels yet.
        -- Enter {c2}. If the pair was not labeled, then voilà, you're already there. No need to be bothered by remaining labels - those are guaranteed "safe" letters -, just continue editing.
        -- Else: select a label. In case of multiple groups, first switch to the desired one, using <space> (step back with <tab>, if needed).
        "ggandor/leap.nvim",
        config = function()
            Utils.callback_if_ok_msg("leap", function(leap)
                leap.add_default_mappings()

                vim.keymap.del({'x', 'o'}, 'x')
                vim.keymap.del({'x', 'o'}, 'X')
                -- To set alternative keys for "exclusive" selection:
                vim.keymap.set({'x', 'o'}, "t", '<Plug>(leap-forward-till)')
                vim.keymap.set({'x', 'o'}, "t", '<Plug>(leap-backward-till)')
            end)
        end,
    },
    "tzachar/highlight-undo.nvim",
}
