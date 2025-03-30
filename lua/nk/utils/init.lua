local Utils = {}

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

---@return string? file_path if it is found
local function get_caller_file()
    local info = debug.getinfo(3, "S")
    if info and info.source then
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
---@param error_level integer?
function Utils.notify(message, error_level)
    local caller = get_caller_file()
    caller = caller and "[" .. caller .. "] " or ""
    vim.notify(caller .. message, error_level or vim.log.levels.INFO)
end

---@param message string
function Utils.notify_error(message)
    local caller = get_caller_file()
    caller = caller and "[" .. caller .. "] " or ""
    vim.notify(caller .. message, vim.log.levels.ERROR)
end

---@return string "/" or "\\"
function Utils.slash()
    return package.config:sub(1, 1)
end

---@param files_path string Folder path to where initiate the foreach loop.
---@param callback function Function to be called for each item found.
---@param ignore string[]? Ignore some specific item on the foreach loop.
---@param add_dirs boolean? Should also callback with folders.
---@param only_dirs boolean? Should only callback with folders, depends on add_dirs.
function Utils.foreach_filename(files_path, callback, ignore, add_dirs, only_dirs)
    only_dirs = add_dirs == true and only_dirs == true
    ignore = ignore or {}

    local ok, scandir = pcall(require, "plenary.scandir")
    if ok then
        if files_path:sub(1, 1) ~= "/" and files_path:sub(1, 1) ~= "\\" then
            files_path = "/" .. files_path
        end

        ---@diagnostic disable-next-line: param-type-mismatch
        files_path = Utils.path_combine(vim.fn.stdpath("config"), "/lua" .. files_path)
        local paths = scandir.scan_dir(files_path, {
            depth = 1,
            add_dirs = add_dirs or false,
        })
    
        -- Escape special characters in files_path
        local escaped_files_path = files_path:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")

        for _, path in ipairs(paths) do
            local name = path:gsub("^" .. escaped_files_path .. Utils.slash(), "")
            local extension = path:match("%.([^%.]+)$")
            if only_dirs then
                if extension ~= "lua" and not vim.tbl_contains(ignore, name) then
                    callback(name)
                end
            else
                name = name:gsub("%.lua$", "") -- Remove ".lua" at the end
                if not vim.tbl_contains(ignore, name) then
                    callback(name)
                end
            end
        end
    end
end

---@param filetype string|string[]|"global"|"mod"|nil
---@return boolean
function Utils.check_filetype(filetype)
    if filetype == "global" then
        return true
    elseif filetype == "mod" then
        return vim.bo.modifiable
    elseif type(filetype) == "string" then
        local buf = vim.api.nvim_get_current_buf()
        local is_modifiable = vim.api.nvim_buf_get_option(buf, "modifiable")
        return is_modifiable
    elseif type(filetype) == "table" then
        local buf = vim.api.nvim_get_current_buf()
        local type = vim.api.nvim_buf_get_option(buf, "filetype")
        return vim.tbl_contains(filetype, type)
    else
        return false
    end
end

return Utils
