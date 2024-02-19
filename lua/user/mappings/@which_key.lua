local Utils = require("user.utils")

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error >> which-key not found!", vim.log.levels.ERROR)
    return
end

---@alias WhichKeyCommands table<string, table>

---@class WhichKeyRegisteredSection
---@field name string

--- Format: "keymap" = { "action"|function, "action-name" }
---     or  "keymap" = {
---             name = "section-name",
---             "child-keymap" = { "action"|function, "action-name" }
---         }
---@alias WhichKeyRegister table<string, table|WhichKeyRegisteredSection>

---@alias WhichKeyRegisterSpecific table<string, WhichKeyRegister>

local which_key_keymaps = {
    ---@type WhichKeyRegister
    ["global"] = {},
    ---@type WhichKeyRegister
    ["modifiable-buffer"] = {},
    ---@type WhichKeyRegisterSpecific
    ["filetype"] = {},
}

---@param table WhichKeyTable
---@param commands WhichKeyCommands
local function generate_from_which_key_table(table, commands)
    for k, v in pairs(table.keymaps) do
        local command = commands[k]
        if not command then
            Utils.notify_error("Keymap named: '" .. k .. "' couldn't find its command!")
        else
            local keymap = type(v) == "string" and v or v.keymap
            local filetype = type(v) == "string" and table.filetype or v.filetype

            if filetype == "global" or filetype == "modifiable-buffer" then
                which_key_keymaps[filetype] = vim.tbl_deep_extend(
                    "force", which_key_keymaps[filetype], { [keymap] = command })
            elseif type(filetype) == "string" then
                local aux = {
                    [filetype] = { [keymap] = command }
                }
                which_key_keymaps["filetype"] = vim.tbl_deep_extend(
                    "force", which_key_keymaps["filetype"], aux)
            else -- string[]
                for _, value in ipairs(filetype) do
                    local aux = {
                        [value] = { [keymap] = command }
                    }
                    which_key_keymaps["filetype"] = vim.tbl_deep_extend(
                        "force", which_key_keymaps["filetype"], aux)
                end
            end
        end
    end
end

---@param section WhichKeySection
---@param commands WhichKeyCommands
local function generate_from_which_key_section(section, commands)
    for k, v in pairs(section.child_keymaps) do
        local command = commands[k]
        if not command then
            Utils.notify(k)
            Utils.notify_table(commands)
            Utils.notify_error("Keymap named: '" .. k .. "' couldn't find its command. Section: '" .. section.name .. "'.")
        else
            local keymap = type(v) == "string" and v or v.keymap
            local filetype = type(v) == "string" and section.filetype or v.filetype

            if filetype == "global" or filetype == "modifiable-buffer" then
                local aux = {
                    [section.keymap] = {
                        name = section.name,
                        [keymap] = command,
                    }
                }
                which_key_keymaps[filetype] = vim.tbl_deep_extend(
                    "force", which_key_keymaps[filetype], aux)
            elseif type(filetype) == "string" then
                local aux = {
                    [filetype] = {
                        [section.keymap] = {
                            name = section.name,
                            [keymap] = command,
                        }
                    }
                }
                which_key_keymaps["filetype"] = vim.tbl_deep_extend(
                    "force", which_key_keymaps["filetype"], aux)
            else -- string[]
                for _, value in ipairs(filetype) do
                    local aux = {
                        [value] = {
                            [section.keymap] = {
                                name = section.name,
                                [keymap] = command,
                            }
                        }
                    }
                    which_key_keymaps["filetype"] = vim.tbl_deep_extend(
                        "force", which_key_keymaps["filetype"], aux)
                end
            end
        end
    end
end

---@param sections WhichKeySection[]
---@param commands WhichKeyCommands
local function generate_from_which_key_section_array(sections, commands)
    for _, section in ipairs(sections) do
        generate_from_which_key_section(section, commands)
    end
end

---@param array table<integer, WhichKeyTable|WhichKeySection>
---@param commands WhichKeyCommands
local function generate_from_which_key_array(array, commands)
    for _, v in ipairs(array) do
        if v.name ~= nil then -- WhichKeySection
            generate_from_which_key_section(v, commands)
        else -- WhichKeyTable
            generate_from_which_key_table(v, commands)
        end
    end
end

local function register()
    which_key.register(which_key_keymaps["global"], {
        mode = "n",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
        pattern = "*",
        callback = function()
            local buffer = vim.api.nvim_get_current_buf()
            if vim.api.nvim_buf_get_option(buffer, "modifiable") then
                which_key.register(which_key_keymaps["modifiable-buffer"], {
                    mode = "n",
                    prefix = "<leader>",
                    buffer = buffer,
                    silent = true,
                    noremap = true,
                    nowait = true,
                })
            end
        end
    })

    for filetype, filetype_keymaps in pairs(which_key_keymaps["filetype"]) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype,
            callback = function()
                which_key.register(filetype_keymaps, {
                    mode = "n",
                    prefix = "<leader>",
                    buffer = vim.api.nvim_get_current_buf(),
                    silent = true,
                    noremap = true,
                    nowait = true,
                })
            end
        })
    end
end

local keymaps = require("config.which_key")

generate_from_which_key_table(keymaps.vim, require("user.mappings.vim_which_key"))

Utils.foreach_filename("plugins",
    ---@param plugin_name string
    function(plugin_name)
        Utils.callback_if_ok("plugins." .. plugin_name .. ".which_key",
            ---@param plugin_commands WhichKeyCommands
            function(plugin_commands)
                local plugin_keymaps = keymaps[plugin_name]
                if plugin_keymaps ~= nil then
                    if plugin_keymaps.keymaps ~= nil then -- WhichKeyTable
                        generate_from_which_key_table(plugin_keymaps, plugin_commands)
                    elseif plugin_keymaps.name ~= nil then -- WhichKeySection
                        generate_from_which_key_section(plugin_keymaps, plugin_commands)
                    else -- WhichKeySection[]
                        generate_from_which_key_section_array(plugin_keymaps, plugin_commands)
                    end
                elseif keymaps.array[plugin_name] ~= nil then
                    generate_from_which_key_array(keymaps.array[plugin_name], plugin_commands)
                else
                    Utils.notify("Keymaps for '" .. plugin_name .. "' which-key configuration not found!", vim.log.levels.WARN)
                end
            end
        )
    end,
{}, true)

register()
