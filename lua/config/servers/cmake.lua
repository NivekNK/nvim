local Utils = require("user.utils")

return {
    lang = "cmake",
    opts = {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        init_options = {
            buildDirectory = "out" .. Utils.slash() .. "build",
        },
        root_dir = Utils.root_pattern("CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake"),
        single_file_support = true,
    },
}
