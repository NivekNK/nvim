return {
	lang = {
		"javascript",
		"typescript",
	},
	opts = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		init_options = {
			hostInfo = "neovim",
		},
		root_dir = require("user.utils").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
		single_file_support = true,
	},
}
