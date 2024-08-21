local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>s",
            group = "Search",
            buffer = true,
        },
        {
            "<leader>sf",
            "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
            desc = "Files",
            buffer = true,
        },
        {
            "<leader>st",
            "<cmd>Telescope live_grep theme=ivy<CR>",
            desc = "Text",
            buffer = true,
        },
        {
            "<leader>sb",
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false, layout_config = { height = 8 } }))<CR>",
            desc = "Buffers",
            buffer = true,
        },
        {
            "<leader>su",
            "<cmd>Telescope undo<CR>",
            desc = "Undo",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>sk",
            "<cmd>Telescope keymaps<CR>",
            desc = "Keymaps",
            buffer = true,
        },
    })

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
            "<leader>gf",
            "<cmd>Telescope git_status<CR>",
            desc = "Changed Files",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gh",
            "<cmd>Telescope git_commits<CR>",
            desc = "Commit History",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>gb",
            "<cmd>Telescope git_branches<CR>",
            desc = "Branches",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })

    wk.add({
        {
            "<leader>p",
            group = "LSP",
            buffer = true,
        },
        {
            "<leader>pe",
            "<cmd>Telescope lsp_references<CR>",
            desc = "References",
            buffer = true,
        },
    })
end

return M
