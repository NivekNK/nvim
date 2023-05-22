local cmake_tools_config = {
    cmake_command = "cmake",
    cmake_build_directory = "",
    cmake_build_directory_prefix = "out/build/", -- when cmake_build_directory is "", this option will be activated
    cmake_generate_options = {
        "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1",
    },
    cmake_regenerate_on_save = true,         -- Saves CMakeLists.txt file only if mofified.
    cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
    cmake_build_options = {},
    cmake_console_size = 10,                 -- cmake output window height
    cmake_console_position = "belowright",   -- "belowright", "aboveleft", ...
    cmake_show_console = "always",           -- "always", "only_on_error"
    cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
    }, -- dap configuration, optional
    cmake_variants_message = {
        short = { show = true },
        long = { show = true, max_length = 40 },
    },
}

return {
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local cmake_tools_ok, cmake_tools = pcall(require, "cmake-tools")
            if not cmake_tools_ok then
                vim.notify("[cpp] Error loading cmake-tools!", vim.log.levels.ERROR)
                return
            end
            local cpp_cmake_tools = require("plugins.cpp.cmake-tools")
            cpp_cmake_tools.setup(cmake_tools_config)
            cmake_tools.setup(cmake_tools_config)
        end,
    },
}
