local Utils = require("user.utils")

local M = {}

M.diagnostic_enabled = true

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
        },
        {
            "<leader>pv",
            function()
                M.diagnostic_enabled = !M.diagnostic_enabled
                if M.diagnostic_enabled then
                    vim.diagnostic.enable(vim.api.nvim_get_current_buf())
                else
                    vim.diagnostic.disable(vim.api.nvim_get_current_buf())
                end
            end,
            desc = "Toggle Virtual Text",
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
