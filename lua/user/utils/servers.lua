local M = {}

local Utils = require("user.utils")

local servers_lsp = nil
local servers_lang = nil
local servers_formatter = nil

M.lsp = function()
    if servers_lsp ~= nil then
        return servers_lsp
    end

    servers_lsp = require("config.servers.@detail")
    Utils.foreach_filename("/config/servers", function(server_name)
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
    end, { "@detail" })
    return servers_lsp
end

M.lang = function()
    if servers_lang ~= nil then
        return servers_lang
    end

    servers_lang = {}
    Utils.foreach_filename("/config/servers", function(server_name)
        local server = require("config.servers." .. server_name)
        if server.lang then
            if type(server.lang) == "string" then
                table.insert(servers_lang, server.lang)
            elseif type(server.lang) == "table" then
                for _, lang in ipairs(server.lang) do
                    table.insert(servers_lang, lang)
                end
            else
                Utils.notify_error("Error >> server.lang should be a table or string for: " .. server_name .. "!")
            end
        else
            Utils.notify_error("Error >> server.lang doesn't exists for: " .. server_name .. "!")
        end
    end, { "@detail" })
    return servers_lang
end

M.formatter = function()
    if servers_formatter ~= nil then
        return servers_formatter
    end

    servers_formatter = {}
    Utils.foreach_filename("/config/servers", function(server_name)
        local server = require("config.servers." .. server_name)
        if server.formatter then
            if server.lang then
                if type(server.lang) == "string" then
                    if Utils.formatter.get_filetype_formatters_count(server.lang) > 0 then
                        local filetype_formatters = Utils.formatter.get_filetype_formatters(server.lang)
                        Utils.callback_if_ok("formatter.util", function(util)
                            servers_formatter[server.lang] = server.formatter(filetype_formatters, util)
                        end)
                    end
                elseif type(server.lang) == "table" then
                    for _, lang in ipairs(server.lang) do
                        if Utils.formatter.get_filetype_formatters_count(lang) > 0 then
                            local filetype_formatters = Utils.formatter.get_filetype_formatters(lang)
                            Utils.callback_if_ok("formatter.util", function(util)
                                local formatters = server.formatter(filetype_formatters, util)
                                if formatters[lang] then
                                    servers_formatter[lang] = formatters[lang]
                                end
                            end)
                        end
                    end
                else
                    Utils.notify_error("Error >> server.lang should be a table or string for: " .. server_name .. "!")
                end
            else
                Utils.notify_error("Error >> server.lang doesn't exists for: " .. server_name .. "!")
            end
        end
    end, { "@detail" })
    return servers_formatter
end

return M
