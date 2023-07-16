local servers = require("config.servers.@detail")
local Utils = require("user.utils")

Utils.foreach_filename("/config/servers", function(server_name)
    if server_name ~= "@detail" then
        local server = require("config.servers." .. server_name)
        if server.lang then
            if type(server.lang) == "string" then
                servers[server.lang] = server.opts == "ignore" and "ignore" or server_name
            elseif type(server.lang) == "table" then
                for _, lang in ipairs(server.lang) do
                    servers[lang] = server.opts == "ignore" and "ignore" or server_name
                end
            else
                Utils.notify_error("Error >> server.lang should be a table or string for: " .. server_name .. "!")
            end
        else
            Utils.notify_error("Error >> server.lang doesn't exists for: " .. server_name .. "!")
        end
    end
end)

return servers
