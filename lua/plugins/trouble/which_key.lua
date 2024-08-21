local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>1",
            "<cmd>TroubleToggle<CR>",
            desc = "Errors",
            buffer = true,
        }
    })
end

return M
