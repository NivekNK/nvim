local Utils = require("user.utils")

local lsp = {
    declaration = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" },
}

if Utils.require_check("lspsaga") then
    lsp.peek_definition = { "<cmd>Lspsaga peek_definition<CR>", "Peek definition" }
    lsp.code_action = { "<cmd>Lspsaga code_action<CR>", "Code Action" }
    lsp.rename = { "<cmd>Lspsaga rename ++project<CR>", "Rename" }
end

return lsp;
