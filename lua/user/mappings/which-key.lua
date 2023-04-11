local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error loading which-key!", vim.log.levels.ERROR)
    return
end

local commands = {
    move_to_panel_up = { "<cmd>wincmd k<CR>", "which_key_ignore" },
    move_to_panel_down = { "<cmd>wincmd j<CR>", "which_key_ignore" },
    move_to_panel_left = { "<cmd>wincmd h<CR>", "which_key_ignore" },
    move_to_panel_right = { "<cmd>wincmd l<CR>", "which_key_ignore" },
    window_previous = { "<cmd>bprevious<CR>", "Window Previous" },
    window_next = { "<cmd>bnext<CR>", "Window Next" },
    window_vertical_split = { "<cmd>vsplit<CR>", "Window Vertical Split" },
    window_horizontal_split ={ "<cmd>split<CR>", "Window Horizontal Split" }
}

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

for _, path in ipairs(paths) do
    local plugin_name = string.gsub(path, plugins_path .. package.config:sub(1, 1), "")
    plugin_name = plugin_name:match("([^/]*).lua$") or plugin_name:match("([^/]*)$")
    local has_commands, plugin_commands = pcall(require, "plugins." .. plugin_name .. ".which_key")
    if has_commands then
        commands = vim.tbl_deep_extend("force", commands, plugin_commands)
    end
end

local keymaps = require("config.which_key")
local keymaps_commands = {}
for _, plugin_keymaps in pairs(keymaps) do
    for key, keymap in pairs(plugin_keymaps) do
        keymaps_commands[keymap] = commands[key]
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
