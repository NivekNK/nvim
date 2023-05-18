return {
    "nvim-lua/plenary.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[ colorscheme tokyonight-moon ]])
        end,
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
        -- surr*ound_words             ysiw)           (surround_words)
        -- *make strings               ys$"            "make strings"
        -- [delete ar*ound me!]        ds]             delete around me!
        -- remove <b>HTML t*ags</b>    dst             remove HTML tags
        -- 'change quot*es'            cs'"            "change quotes"
        -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        -- delete(functi*on calls)     dsf             function calls
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
}
