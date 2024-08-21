local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>p",
            group = "LSP",
            buffer = true,
        },
        {
            "<leader>pd",
            "<cmd>lua vim.lsp.buf.declaration()<CR>",
            desc = "Go to declaration",
            buffer = true,
        }
    })

    if Utils.require_check("lspsaga") then
        wk.add({
            {
                "<leader>pp",
                "<cmd>Lspsaga peek_definition<CR>",
                desc = "Peek definition",
                buffer = true,
            },
            {
                "<leader>pa",
                "<cmd>Lspsaga code_action<CR>",
                desc = "Code Action",
                buffer = true,
                cond = function()
                    return Utils.check_filetype("modifiable-file")
                end,
            },
            {
                "<leader>pr",
                "<cmd>Lspsaga rename ++project<CR>",
                desc = "Rename",
                buffer = true,
                cond = function()
                    return Utils.check_filetype("modifiable-file")
                end,
            },
        })

    end
end

return M
