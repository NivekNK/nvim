local plenary_ok, scandir = pcall(require, "plenary.scandir")
if not plenary_ok then
    vim.notify("[lsp] Error loading plenary.scandir!", vim.log.levels.ERROR)
    return {}
end

local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins/lsp/dependencies"
local paths = scandir.scan_dir(plugins_path, {
    depth = 1,
    add_dirs = true
})

local dependencies = {}
for _, path in ipairs(paths) do
    local plugin_name = string.gsub(path, plugins_path .. package.config:sub(1, 1), "")
    plugin_name = plugin_name:match("([^/]*).lua$") or plugin_name:match("([^/]*)$")
    local plugin_ok, plugin = pcall(require, "plugins.lsp.dependencies." .. plugin_name)
    if plugin_ok then
        table.insert(dependencies, plugin)
    end
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = dependencies
}
