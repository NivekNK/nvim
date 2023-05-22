local cmake = require("cmake-tools")
local utils = require("cmake-tools.utils")
local const = require("cmake-tools.const")
local Types = require("cmake-tools.types")
local Path = require("plenary.path")
local Result = require("cmake-tools.result")

local Config = require("cmake-tools.config")
local config = Config:new(const)

local M = {}

--- Setup cmake-tools
function M.setup(values)
    const = vim.tbl_deep_extend("force", const, values)
    config = Config:new(const)
    cmake.run = M.run
end

local function get_path(str, sep)
    sep = sep or "/"
    return str:match("(.*" .. sep .. ")")
end

-- Run executable targets
function M.run(opt, callback)
    if not utils.has_active_job() then
        return
    end

    local result = config:get_launch_target()
    local result_code = result.code
    -- print(Types[result_code])
    if result_code == Types.NOT_CONFIGURED or result_code == Types.CANNOT_FIND_CODEMODEL_FILE then
        -- Configure it
        return cmake.generate({ bang = false, fargs = utils.deepcopy(opt.fargs) }, function()
            cmake.run(opt, callback)
        end)
    elseif result_code == Types.NOT_SELECT_LAUNCH_TARGET
        or result_code == Types.NOT_A_LAUNCH_TARGET
        or result_code == Types.NOT_EXECUTABLE
    then
        -- Re Select a target that could launch
        return cmake.select_launch_target(function()
            vim.schedule(function()
                cmake.run(opt, callback)
            end)
        end, false)
    else -- if result_code == Types.SELECTED_LAUNCH_TARGET_NOT_BUILT
        -- Build select launch target every time
        config.build_target = config.launch_target
        return cmake.build({ fargs = utils.deepcopy(opt.fargs) }, function()
            vim.schedule(function()
                result = config:get_launch_target()
                -- print(utils.dump(result))
                -- print("TARGET", target_path)
                local target_path = result.data
                local is_win32 = vim.fn.has("win32")
                if (is_win32 == 1) then
                    -- Prints the output in the same cmake window as in wsl/linux
                    local new_s = get_path(target_path, "\\")
                    -- print(getPath(target_path,sep))
                    return utils.execute(target_path, {
                        bufname = vim.fn.expand("%:p"),
                        cmake_launch_path = new_s,
                        cmake_console_position = const.cmake_console_position,
                        cmake_console_size = const.cmake_console_size,
                        cmake_launch_args = cmake:get_launch_args()
                    })
                else
                    -- print("target_path: " .. target_path)
                    local new_s = get_path(target_path, "/")
                    return utils.execute('"' .. target_path .. '"', {
                        bufname = vim.fn.expand("%:t:r"),
                        cmake_launch_path = new_s,
                        cmake_console_position = const.cmake_console_position,
                        cmake_console_size = const.cmake_console_size,
                        cmake_launch_args = cmake:get_launch_args()
                    })
                end
            end)
        end)
    end
end

-- Retrieve launch target path: self.launch_target
-- it will first check if this launch target is built
Config.get_launch_target = function(self)
    local check_result = self:check_launch_target()
    if check_result.code ~= Types.SUCCESS then
        return check_result
    end
    local target_info = check_result.data

    -- print(utils.dump(target_info))
    local target_path = target_info["artifacts"][1]["path"]

    local uname = vim.loop.os_uname()
    local os = uname.sysname
    if (os:find("Windows") or (os == "Linux" and uname.release:lower():find("microsoft"))) and target_path:find("/") then
        target_path = string.gsub(target_path, "/", "\\")
    end

    target_path = Path:new(target_path)
    if not target_path:is_absolute() then
        -- then it is a relative path, based on build directory
        local build_directory = Path:new(vim.loop.cwd(), self.build_directory)
        target_path = build_directory / target_path
    end
    -- else it is an absolute path

    if not target_path:is_file() then
        return Result:new(
            Types.SELECTED_LAUNCH_TARGET_NOT_BUILT,
            nil,
            "Selected target is not built: " .. target_path.filename
        )
    end

    return Result:new(Types.SUCCESS, target_path.filename, "yeah, that's good")
end

return M
