return {
	lang = "astro",
	opts = function()
		vim.filetype.add({
			extension = {
				astro = "astro",
			},
		})

		return {
			cmd = { "astro-ls", "--stdio" },
			filetypes = { "astro" },
			init_options = {
				typescript = {},
			},
			root_dir = require("user.utils").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
		}
	end,
	formatter = function(_, _)
		return {
			exe = "prettierd",
			args = { vim.api.nvim_buf_get_name(0) },
			stdin = true,
		}
	end,
}
