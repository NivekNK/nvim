local icons = require("config.icons")
local cmake_tools = require("cmake-tools")

return {
    lualine_c = {
        {
            function()
                return "CMake"
            end,
            cond = function()
                return cmake_tools.is_cmake_project()
            end,
        },
        {
            function()
                local preset = cmake_tools.get_configure_preset()
                return "Preset: [" .. (preset or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectConfigurePreset")
                end
            end,
        },
        {
            function()
                local type = cmake_tools.get_build_type()
                return "Type: [" .. (type or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and not cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectBuildType")
                end
            end,
        },
        {
            function()
                local kit = cmake_tools.get_kit()
                return "Kit: [" .. (kit or icons.no_text) .. "]"
            end,
            icon = icons.trace,
            cond = function()
                return cmake_tools.is_cmake_project() and not cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectKit")
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
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeBuild")
                end
            end,
        },
        -- HACK: For now this is commented, should fix in the future
        {
            function()
                local preset = cmake_tools.get_build_preset()
                return "[" .. (preset or icons.no_text) .. "]"
            end,
            icon = icons.search,
            cond = function()
                return cmake_tools.is_cmake_project() and cmake_tools.has_cmake_preset()
            end,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectBuildPreset")
                end
            end,
        },
        {
            function()
                local target = cmake_tools.get_build_target()
                return "[" .. (target or icons.no_text) .. "]"
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectBuildTarget")
                end
            end,
        },
        -- {
        --     function()
        --         return "Debug " .. icons.debug
        --     end,
        --     cond = cmake_tools.is_cmake_project,
        --     on_click = function(n, mouse)
        --         if n == 1 and mouse == "l" then
        --             vim.cmd("CMakeDebug")
        --         end
        --     end,
        -- },
        {
            function()
                return "Run " .. icons.gitsigns.deleted
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeRun")
                end
            end,
        },
        {
            function()
                local target = cmake_tools.get_launch_target()
                return "[" .. (target or icons.no_text) .. "]"
            end,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectLaunchTarget")
                end
            end,
        },
    },
}
