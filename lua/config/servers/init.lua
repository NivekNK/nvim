local plenary_ok, scandir = pcall(require, "plenary.scandir")
if not plenary_ok then
    vim.notify("[servers] Error loading plenary.scandir!", vim.log.levels.ERROR)
    return {}
end

local servers_path = vim.fn.stdpath("config") .. "/lua/config/servers"
local paths = scandir.scan_dir(servers_path, {
    depth = 1,
    add_dirs = false,
})

local servers = require("config.servers.langs")

for _, path in ipairs(paths) do
    local server_name = string.gsub(path, servers_path .. package.config:sub(1, 1), "")
    server_name = server_name:match("([^/]*).lua$")
    if server_name ~= "init" and server_name ~= "langs" then
        local server = require("config.servers." .. server_name)
        servers[server.lang] = server.opts == "ignore" and "ignore" or server_name
    end
end

return servers
