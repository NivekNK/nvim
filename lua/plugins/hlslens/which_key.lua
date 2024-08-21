local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>H",
            "<cmd>nohlsearch<CR>",
            desc = "Hide Highlight",
            buffer = true,
        }
    })
end

return M
