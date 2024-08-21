local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>s",
            group = "Search",
            buffer = true,
            cond = function ()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>sy",
            "<cmd>Telescope yank_history<CR>",
            desc = "Yank History",
            buffer = true,
            cond = function ()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })
end

return M
