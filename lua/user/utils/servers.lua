local M = {}

local servers_lsp = nil
local servers_lang = nil

M.lsp = function()
    if servers_lsp ~= nil then
        return servers_lsp
    end

    local Utils = require("user.utils")
    servers_lsp = require("config.servers.@detail")
    Utils.foreach_filename("/config/servers", function(server_name)
        if server_name ~= "@detail" then
            local server = require("config.servers." .. server_name)
            if server.lang then
                if type(server.lang) == "string" then
                    servers_lsp[server.lang] = server.opts == "ignore" and "ignore" or server_name
                elseif type(server.lang) == "table" then
                    for _, lang in ipairs(server.lang) do
                        servers_lsp[lang] = server.opts == "ignore" and "ignore" or server_name
                    end
                else
                    Utils.notify_error("Error >> server.lang should be a table or string for: " .. server_name .. "!")
                end
            else
                Utils.notify_error("Error >> server.lang doesn't exists for: " .. server_name .. "!")
            end
        end
    end)
    return servers_lsp
end

M.lang = function()
    if servers_lang ~= nil then
        return servers_lang
    end

    servers_lang = {}
    for lang, _ in pairs(M.lsp()) do
        table.insert(servers_lang, lang)
    end
    return servers_lang
end

return M
