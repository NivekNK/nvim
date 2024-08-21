local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>v",
            "<cmd>MarkdownPreviewToggle<CR>",
            desc = "Preview Markdown",
            buffer = true,
            cond = function()
                return Utils.check_filetype("markdown")
            end
        }
    })
end

return M
