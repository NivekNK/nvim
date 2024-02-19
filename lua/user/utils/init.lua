local Utils = {}

---@param table table
function Utils.print_table(table)
    print(vim.inspect(table))
end

---@param table table
function Utils.notify_table(table)
    vim.notify(vim.inspect(table))
end

---@return boolean
function Utils.is_windows()
    local uname = vim.loop.os_uname()
    local os = uname.sysname
    if os:find("Windows") or (os == "Linux" and uname.release:lower():find("microsoft")) then
        return true
    end
    return false
end

---@param first string
---@param second string
---@param sep string?
---@return string
function Utils.path_combine(first, second, sep)
    if sep then
        first = first:gsub("[/\\]", sep)
        second = second:gsub("[/\\]", sep)
    else
        if Utils.is_windows() then
            first = first:gsub("/", "\\")
            second = second:gsub("/", "\\")
        else
            first = first:gsub("\\", "/")
            second = second:gsub("\\", "/")
        end
    end
    return first .. second
end

---@param path string
---@param sep string?
---@return string
function Utils.path_create(path, sep)
    if sep then
        path = path:gsub("[/\\]", sep)
    else
        if Utils.is_windows() then
            path = path:gsub("/", "\\")
        else
            path = path:gsub("\\", "/")
        end
    end
    return path
end

---@return string? file_path if it is found
local function get_caller_file()
    local info = debug.getinfo(3, "S")
    if info and info.source and info.source:sub(1, 1) == "@" then
        ---@diagnostic disable-next-line: param-type-mismatch
        local config_path = Utils.path_combine(vim.fn.stdpath("config"), "/lua/")
        local file_path = info.source:sub(#config_path + 2)
        file_path = file_path:sub(1, -5)          -- Remove last 5 characters (".lua")
        file_path = file_path:gsub("/", ".")      -- Replace slashes with dots
        file_path = file_path:gsub("%.init$", "") -- Remove ".init" at the end
        return file_path
    end
    return nil
end

---@param message string
---@param error_level integer
function Utils.notify(message, error_level)
    local caller = get_caller_file()
    caller = caller and "[" .. caller .. "] " or ""
    vim.notify(caller .. message, error_level or vim.log.levels.ERROR)
end

---@param message string
function Utils.notify_error(message)
    local caller = get_caller_file()
    caller = caller and "[" .. caller .. "] " or ""
    vim.notify(caller .. message, vim.log.levels.ERROR)
end

---@param required_name string
---@param message string
---@param error_level integer
---@return any
function Utils.get_if_ok(required_name, message, error_level)
    local ok, required = pcall(require, required_name)
    if not ok then
        local caller = get_caller_file()
        caller = caller and "[" .. caller .. "] " or ""
        vim.notify(
            caller .. (message or ("Error >> " .. required_name .. " not found!")),
            error_level or vim.log.levels.ERROR
        )
        return {}
    end
    return required
end

---@param required_name string
---@param callback function
---@param message string?
---@param error_level integer?
---@return any
function Utils.callback_if_ok(required_name, callback, message, error_level)
    local ok, required = pcall(require, required_name)
    if not ok then
        if message then
            local caller = get_caller_file()
            caller = caller and "[" .. caller .. "] " or ""
            vim.notify(caller .. message, error_level or vim.log.levels.ERROR)
        end
        return {}
    end
    callback(required)
    return required
end

---@param required_name string
---@param callback function
---@param message string?
---@param error_level integer?
---@return any
function Utils.callback_if_ok_msg(required_name, callback, message, error_level)
    local ok, required = pcall(require, required_name)
    if not ok then
        local caller = get_caller_file()
        caller = caller and "[" .. caller .. "] " or ""
        vim.notify(
            caller .. (message or ("Error >> " .. required_name .. " not found!")),
            error_level or vim.log.levels.ERROR
        )
        return {}
    end
    callback(required)
    return required
end

---@param required_names string[]
---@param callback function
---@param message string?
---@param error_level integer?
---@return any
function Utils.callback_if_ok_msg_mult(required_names, callback, message, error_level)
    local required = {}
    for _, v in ipairs(required_names) do
        local ok, aux_required = pcall(require, v)
        if not ok then
            local caller = get_caller_file()
            caller = caller and "[" .. caller .. "] " or ""
            vim.notify(caller .. (message or ("Error >> " .. v .. " not found!")), error_level or vim.log.levels.ERROR)
            return {}
        end
        required[v] = aux_required
    end
    callback(required)
    return required
end

---@param required string
---@return boolean
function Utils.require_check(required)
    local ok, _ = pcall(require, required)
    return ok
end

---@return string "/" or "\\"
function Utils.slash()
    return package.config:sub(1, 1)
end

---@param table table
---@param value any
---@return boolean
function Utils.table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

---@param table table
---@param value any
---@return boolean
function Utils.table_contains_value(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

---@param table table
---@param key string
---@return boolean
function Utils.table_contains_key(table, key)
    for k, _ in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

---@param files_path string Folder path to where initiate the foreach loop.
---@param callback function Function to be called for each item found.
---@param ignore string[]? Ignore some specific item on the foreach loop.
---@param add_dirs boolean? Should also callback with folders.
---@param only_dirs boolean? Should only callback with folders, depends on add_dirs.
function Utils.foreach_filename(files_path, callback, ignore, add_dirs, only_dirs)
    only_dirs = add_dirs == true and only_dirs == true
    ignore = ignore or {}

    Utils.callback_if_ok_msg("plenary.scandir", function(scandir)
        if files_path:sub(1, 1) ~= "/" and files_path:sub(1, 1) ~= "\\" then
            files_path = "/" .. files_path
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        files_path = Utils.path_combine(vim.fn.stdpath("config"), "/lua" .. files_path)
        local paths = scandir.scan_dir(files_path, {
            depth = 1,
            add_dirs = add_dirs or false,
        })

        for _, path in ipairs(paths) do
            local name = string.gsub(path, files_path .. Utils.slash(), "")
            local extension = path:match("%.([^%.]+)$")
            if only_dirs then
                if extension ~= "lua" and not Utils.table_contains_value(ignore, name) then
                    callback(name)
                end
            else
                name = name:gsub("%.lua$", "") -- Remove ".lua" at the end
                if not Utils.table_contains_value(ignore, name) then
                    callback(name)
                end
            end
        end
    end)
end

function Utils.root_pattern(...)
    local patterns = vim.tbl_flatten({ ... })
    local rp = require("user.utils.@root_pattern")

    local function matcher(path)
        for _, pattern in ipairs(patterns) do
            for _, p in ipairs(vim.fn.glob(rp.path_join(rp.escape_wildcards(path), pattern), true, true)) do
                if rp.exists(p) then
                    return path
                end
            end
        end
    end

    return function(startpath)
        startpath = rp.strip_archive_subpath(startpath)
        return rp.search_ancestors(startpath, matcher)
    end
end

---@param current_filetype string
---@return boolean
function Utils.formatter_configured(current_filetype)
    local efm = require("config.servers.@efm")
    return efm[current_filetype] ~= nil
end

---@return string
function Utils.get_home_directory()
    if Utils.is_windows() then
        ---@diagnostic disable-next-line: return-type-mismatch
        return os.getenv("USERPROFILE")
    else
        ---@diagnostic disable-next-line: return-type-mismatch
        return os.getenv("HOME")
    end
end

---@param hue integer
---@param saturation integer
---@param lightness integer
---@return string
function Utils.hsl_to_hex(hue, saturation, lightness)
    lightness = lightness / 100
    local chroma = saturation * math.min(lightness, 1 - lightness) / 100

    local function f(angle)
        local k = (angle + hue / 30) % 12
        local color = lightness - chroma * math.max(math.min(k - 3, 9 - k, 1), -1)
        return string.format("#%02x", math.floor(255 * color))
    end

    return f(0) .. f(8) .. f(4)
end

---@param table table
---@return boolean
function Utils.table_is_array(table)
    for k, _ in pairs(table) do
        if type(k) == "number" then
            return true
        else
            return false
        end
    end
end

---@param path string
---@return string
function Utils.stdpath(path)
    local aux = vim.fn.stdpath(path)
    if not aux then
        return ""
    elseif type(aux) == "table" then
        return #aux >= 1 and aux[1] or ""
    else
        return aux
    end
end

return Utils
