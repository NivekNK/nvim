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
                local target = cmake_tools.get_build_target()
                return "Build: [" .. (target or icons.no_text) .. "]"
            end,
            icon = icons.gear,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectBuildTarget")
                end
            end,
        },
        {
            function()
                local target = cmake_tools.get_launch_target()
                return "Launch: [" .. (target or icons.no_text) .. "]"
            end,
            icon = icons.launch,
            cond = cmake_tools.is_cmake_project,
            on_click = function(n, mouse)
                if n == 1 and mouse == "l" then
                    vim.cmd("CMakeSelectLaunchTarget")
                end
            end,
        },
    },
}
