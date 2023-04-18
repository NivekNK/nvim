M = {}

local plenary_ok, scandir = pcall(require, "plenary.scandir")
if not plenary_ok then
    vim.notify("[mappings] Error loading plenary.scandir!", vim.log.levels.ERROR)
    return M
end

local servers_path = vim.fn.stdpath("config") .. "/lua/config/servers"
local paths = scandir.scan_dir(servers_path, {
    depth = 1,
    add_dirs = false
})

for _, path in ipairs(paths) do
    local server_name = string.gsub(path, servers_path .. package.config:sub(1, 1), "")
    server_name = server_name:match("([^/]*).lua$")
    if server_name ~= "init" then
        table.insert(M, server_name)
    end
end

return M
