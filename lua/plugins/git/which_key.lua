local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>g",
            group = "Git",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gj",
            "<cmd>lua require('gitsigns').next_hunk()<cr>",
            desc = "Next Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gk",
            "<cmd>lua require('gitsigns').prev_hunk()<cr>",
            desc = "Prev Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>ge",
            "<cmd>lua require('gitsigns').blame_line()<cr>",
            desc = "Blame",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gp",
            "<cmd>lua require('gitsigns').preview_hunk()<cr>",
            desc = "Preview Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gr",
            "<cmd>lua require('gitsigns').reset_hunk()<cr>",
            desc = "Reset Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gR",
            "<cmd>lua require('gitsigns').reset_buffer()<cr>",
            desc = "Reset Buffer",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gs",
            "<cmd>lua require('gitsigns').stage_hunk()<cr>",
            desc = "Stage Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gu",
            "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>",
            desc = "Undo Stage Hunk",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gd",
            "<cmd>Gitsigns diffthis HEAD<CR>",
            desc = "Diff",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })
end

return M
