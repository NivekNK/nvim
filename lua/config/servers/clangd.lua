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
    },
}
