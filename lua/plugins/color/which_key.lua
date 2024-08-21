local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>C",
            group = "Color",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end
        },
        {
            "<leader>Cp",
            "<cmd>CccPick<CR>",
            desc = "Color Picker",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end
        },
        {
            "<leader>Cc",
            "<cmd>CccHighlighterToggle<CR>",
            desc = "Toggle Color",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end
        },
    })
end

return M
