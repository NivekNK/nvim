local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>S",
            "<cmd>TSJToggle<CR>",
            desc = "Toggle Split",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>|",
            "<cmd>Neogen<CR>",
            desc = "Document",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })
end

return M
