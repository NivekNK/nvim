local commands = require("user.mappings.vim_keymaps")

local keymaps = require("config.keymaps")
local keymap_types = { "n", "i", "v", "x" }
for _, keymap_type in ipairs(keymap_types) do
    local current_commands = commands[keymap_type]
    for key, keymap in pairs(keymaps[keymap_type]) do
        vim.keymap.set(keymap_type, keymap, current_commands[key])
    end
end

require("user.mappings.which-key")
