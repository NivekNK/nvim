local Utils = {}

function Utils.print_table(table)
	print(vim.inspect(table))
end

function Utils.notify_table(table)
	vim.notify(vim.inspect(table))
end

function Utils.path_combine(first, second)
	if vim.fn.has("win32") == 1 then
		first = first:gsub("/", "\\")
		second = second:gsub("/", "\\")
		return first .. second
	else
		first = first:gsub("\\", "/")
		second = second:gsub("\\", "/")
		return first .. second
	end
end

local function get_caller_file()
	local info = debug.getinfo(3, "S")
	if info and info.source and info.source:sub(1, 1) == "@" then
		local config_path = Utils.path_combine(vim.fn.stdpath("config"), "/lua/")
		local file_path = info.source:sub(#config_path + 2)
		file_path = file_path:sub(1, -5) -- Remove last 5 characters (".lua")
		file_path = file_path:gsub("/", ".") -- Replace slashes with dots
		file_path = file_path:gsub("%.init$", "") -- Remove ".init" at the end
		return file_path
	end
	return nil
end

function Utils.notify(message, error_level)
	local caller = get_caller_file()
	caller = caller and "[" .. caller .. "] " or ""
	vim.notify(caller .. message, error_level or vim.log.levels.ERROR)
end

function Utils.notify_error(message)
	local caller = get_caller_file()
	caller = caller and "[" .. caller .. "] " or ""
	vim.notify(caller .. message, vim.log.levels.ERROR)
end

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

function Utils.require_check(required)
	local ok, _ = pcall(require, required)
	return ok
end

function Utils.slash()
	return package.config:sub(1, 1)
end

function Utils.table_contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

function Utils.foreach_filename(files_path, callback, ignore, add_dirs, only_dirs)
	if not ignore then
		ignore = {}
	end

	Utils.callback_if_ok_msg("plenary.scandir", function(scandir)
		if files_path:sub(1, 1) ~= "/" and files_path:sub(1, 1) ~= "\\" then
			files_path = "/" .. files_path
		end
		files_path = Utils.path_combine(vim.fn.stdpath("config"), "/lua" .. files_path)
		local paths = scandir.scan_dir(files_path, {
			depth = 1,
			add_dirs = add_dirs or false,
		})

		for _, path in ipairs(paths) do
			local name = string.gsub(path, files_path .. Utils.slash(), "")
			local extension = path:match("%.([^%.]+)$")
			if only_dirs then
				if extension ~= "lua" and not Utils.table_contains(ignore, name) then
					callback(name)
				end
			else
				name = name:gsub("%.lua$", "") -- Remove ".lua" at the end
				if not Utils.table_contains(ignore, name) then
					callback(name)
				end
			end
		end
	end)
end

function Utils.is_windows()
	return string.find(vim.loop.os_uname().sysname, "Windows")
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

return Utils
