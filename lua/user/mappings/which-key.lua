local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error loading which-key!", vim.log.levels.ERROR)
    return
end

local plenary_ok, scandir = pcall(require, "plenary.scandir")
if not status_ok then
    vim.notify("[mappings] Error loading plenary.scandir!", vim.log.levels.ERROR)
    return
end

local function merge_tables(merged_table, ...)
    for _, t in ipairs({...}) do
        for key, value in pairs(t) do
            if (merged_table[key]) then
                vim.notify("Trying to merge to which-key a key already in use, skipping: " ..
                "[Key: " .. vim.inspect(key) .. " - Value: " .. vim.inspect(value) .. "] from table:\n" .. vim.inspect(t),
                vim.log.levels.ERROR)
            else
                merged_table[key] = value
            end
        end
    end
end

local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
local paths = scandir.scan_dir(plugins_path, {
    depth = 1,
    add_dirs = true
})

local merged_keymaps = {}
for _, path in ipairs(paths) do
    local extension = path:match("%.(%w+)$")
    if extension ~= "lua" then
        local plugin_name = string.gsub(path, plugins_path .. package.config:sub(1, 1), "")
        local has_keymaps, plugin_keymaps = pcall(require, "plugins." .. plugin_name .. ".keymaps")
        if has_keymaps and plugin_keymaps.which_key then
            merge_tables(merged_keymaps, plugin_keymaps.which_key)
        end
    end
end
vim.notify(vim.inspect(merged_keymaps))

local opts = {
    mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

which_key.register(merged_keymaps, opts)
