return {
    lang = { "cpp", "c" },
    opts = {
        capabilities = {
            offsetEncoding = { "utf-16" },
        },
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_dir = require("lspconfig.util").root_pattern(
          ".clangd",
          ".clang-tidy",
          ".clang-format",
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac",
          ".git"
        ),
        single_file_support = true,
        on_new_config = function(new_config, _)
            local cmake_tools_ok, cmake_tools = pcall(require, "cmake-tools")
            if cmake_tools_ok then
                cmake_tools.clangd_on_new_config(new_config)
            end
        end,
    },
}
