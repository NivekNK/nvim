local Utils = require("user.utils")

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error >> which-key not found!", vim.log.levels.ERROR)
    return
end

local function table_is_array(table)
    for k, _ in pairs(table) do
        if type(k) == "number" then
            return true
        else
            return false
        end
    end
end

local keymaps_commands = {}
local keymaps = require("config.which_key")
for k, v in pairs(require("user.mappings.vim_which_key")) do
    keymaps_commands[keymaps.vim[k]] = v
end

local function define_array_keymaps(key, plugin_commands)
    if keymaps_commands[key.keymap] then
        if not keymaps_commands[key.keymap].name then
            vim.notify("[mappings] Trying to assing which-key keymap already in use! [" ..
            key.keymap "] for: '" .. key.name "'")
        else
            for k, v in pairs(key.mappings) do
                keymaps_commands[key.keymap][v] = plugin_commands[k]
            end
        end
    else
        local aux = { name = key.name }
        for k, v in pairs(key.mappings) do
            aux[v] = plugin_commands[k]
        end
        keymaps_commands[key.keymap] = aux
    end
end

Utils.foreach_filename("plugins", function(plugin_name)
    Utils.callback_if_ok("plugins." .. plugin_name .. ".which_key", function(plugin_commands)
        if keymaps[plugin_name] then
            if table_is_array(keymaps[plugin_name]) then
                for _, v in ipairs(keymaps[plugin_name]) do
                    define_array_keymaps(v, plugin_commands)
                end
            else
                for k, v in pairs(keymaps[plugin_name]) do
                    keymaps_commands[v] = plugin_commands[k]
                end
            end
        else
            vim.notify("[mappings.which_key] Keymaps for " .. plugin_name .. " which-key configuration not found!",
            vim.log.levels.WARN)
        end
    end)
end, {}, true)

local opts = {
    mode = "n",  -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

which_key.register(keymaps_commands, opts)
