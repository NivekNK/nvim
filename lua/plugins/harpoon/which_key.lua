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
            "<leader>sm",
            "<cmd>NKHarpoonMarksTelescope<CR>",
            desc = "Marks",
            buffer = true,
        }
    })

    wk.add({
        {
            "<leader>m",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Marks",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>M",
            "<cmd>lua require('harpoon'):list():append()<CR>",
            desc = "Add Mark",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>,",
            "<cmd>lua require('harpoon'):list():next()<CR>",
            desc = "Next Mark",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>.",
            "<cmd>lua require('harpoon'):list():prev()<CR>",
            desc = "Prev Mark",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })
end

return M
