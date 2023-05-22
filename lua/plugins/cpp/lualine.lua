local cmake_tools_ok, cmake_tools = pcall(require, "cmake-tools")
if not cmake_tools_ok then
    vim.notify("[cpp.lualine] Error loading cmake-tools!", vim.log.levels.WARN)
    return { lualine_c = {} }
end

local icons = require("config.icons")

local sections = {
    lualine_c = {
        {
            function()
                local preset = cmake_tools.get_configure_preset()
                return "CMake: [" .. (preset and preset or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectConfigurePreset")
                    end
                end
            end,
        },
        {
            function()
                local type = cmake_tools.get_build_type()
                return "CMake: [" .. (type and type or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and not cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectBuildType")
                    end
                end
            end,
        },
        {
            function()
                local kit = cmake_tools.get_kit()
                return "[" .. (kit and kit or icons.no_text) .. "]"
            end,
            icon = icons.trace,
            cond = function()
                return cmake_tools.is_cmake_project() and not cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectKit")
                    end
                end
            end,
        },
        {
            function()
                return "Build"
            end,
            icon = icons.gear,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeBuild")
                    end
                end
            end,
        },
        {
            function()
                local preset = cmake_tools.get_build_preset()
                return "[" .. (preset and preset or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectBuildPreset")
                    end
                end
            end,
        },
        {
            function()
                local target = cmake_tools.get_build_target()
                return "[" .. (target and target or icons.no_text) .. "]"
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectBuildTarget")
                    end
                end
            end,
        },
        {
            function()
                return "Debug " .. icons.debug
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeDebug")
                    end
                end
            end,
        },
        {
            function()
                return "Run " .. icons.gitsigns.deleted
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeRun")
                    end
                end
            end,
        },
        {
            function()
                local target = cmake_tools.get_launch_target()
                return "[" .. (target and target or icons.no_text) .. "]"
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd("CMakeSelectLaunchTarget")
                    end
                end
            end,
        },
    },
}

return sections
