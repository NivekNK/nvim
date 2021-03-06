vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local required_keymaps = {
    "default",
    "telescope",
    "cokeline",
    "lsp",
    "illuminate",
    "dap",
    "color-picker"
}

for _, keymaps in pairs(required_keymaps) do
    local M = require("user.keymaps." .. keymaps)
    if M then
        M.setup()
    end
end
