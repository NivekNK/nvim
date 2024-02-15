local Utils = require("user.utils")

local M = {}

function M.path_join(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
end

function M.escape_wildcards(path)
    return path:gsub("([%[%]%?%*])", "\\%1")
end

function M.exists(filename)
    local stat = vim.loop.fs_stat(filename)
    return stat and stat.type or false
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
    -- Matches regex from zip.vim / tar.vim
    path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "") or ""
    path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
    return path
end

local function is_fs_root(path)
    if Utils.is_windows() then
        return path:match("^%a:$")
    else
        return path == "/"
    end
end

local function dirname(path)
    local strip_dir_pat = "/([^/]+)$"
    local strip_sep_pat = "/$"
    if not path or #path == 0 then
        return
    end
    local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
    if #result == 0 then
        if Utils.is_windows() then
            return path:sub(1, 2):upper()
        else
            return "/"
        end
    end
    return result
end

local function iterate_parents(path)
    local function it(_, v)
        if v and not is_fs_root(v) then
            v = dirname(v)
        else
            return
        end
        if v and vim.loop.fs_realpath(v) then
            return v, path
        else
            return
        end
    end
    return it, path, path
end

function M.search_ancestors(startpath, func)
    vim.validate({ func = { func, "f" } })
    if func(startpath) then
        return startpath
    end
    local guard = 100
    for path in iterate_parents(startpath) do
        -- Prevent infinite recursion if our algorithm breaks
        guard = guard - 1
        if guard == 0 then
            return
        end

        if func(path) then
            return path
        end
    end
end

return M
