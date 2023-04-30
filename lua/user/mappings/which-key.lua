local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error loading which-key!", vim.log.levels.ERROR)
    return
end

local plenary_ok, scandir = pcall(require, "plenary.scandir")
if not plenary_ok then
    vim.notify("[mappings] Error loading plenary.scandir!", vim.log.levels.ERROR)
    return
end

local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
local paths = scandir.scan_dir(plugins_path, {
    depth = 1,
    add_dirs = true
})

local keymaps = require("config.which_key")
local keymaps_commands = {}

local vim_commands = require("user.mappings.vim_which_key")
for key, keymap in pairs(keymaps.vim) do
    keymaps_commands[keymap] = vim_commands[key]
end

for _, path in ipairs(paths) do
    local plugin_name = string.gsub(path, plugins_path .. package.config:sub(1, 1), "")
    plugin_name = plugin_name:match("([^/]*).lua$") or plugin_name:match("([^/]*)$")
    local has_commands, plugin_commands = pcall(require, "plugins." .. plugin_name .. ".which_key")
    if has_commands and keymaps[plugin_name] then
        local plugin_keymaps = keymaps[plugin_name]
        if plugin_keymaps["config"] and plugin_keymaps["mappings"] then
            local aux = {
                name = plugin_keymaps.config.name
            }
            for key, keymap in pairs(plugin_keymaps.mappings) do
                aux[keymap] = plugin_commands[key]
            end
            keymaps_commands[plugin_keymaps.config.keymap] = aux
        else
            for key, keymap in pairs(plugin_keymaps) do
                keymaps_commands[keymap] = plugin_commands[key]
            end
        end
    end
end

local opts = {
    mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true -- use `nowait` when creating keymaps
}

which_key.register(keymaps_commands, opts)
