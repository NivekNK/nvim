return {
	snake_case = { "<cmd>Snek<CR>", "snake_case" },
	pascal_case = { "<cmd>Camel<CR>", "PascalCase" },
	camel_case = { "<cmd>CamelB<CR>", "camelCase" },
	kebab_case = { "<cmd>Kebab<CR>", "kebab-case" },
	-- surr*ound_words             ysiw)           (surround_words)
	surround_word = {
		function()
			vim.api.nvim_input("ysiw")
		end,
		"Word",
	},
	-- *make strings               ys$"            "make strings"
	surround_to_end = {
		function()
			vim.api.nvim_input("ys$\"")
		end,
		"To End",
	},
	-- [delete ar*ound me!]        ds]             delete around me!
	surround_delete_arround = {
		function()
			vim.api.nvim_input("ds")
		end,
		"Delete Arround",
	},
	-- remove <b>HTML t*ags</b>    dst             remove HTML tags
	surround_delete_html_tags = {
		function()
			vim.api.nvim_input("dst")
		end,
		"Delete HTML tags",
	},
	-- 'change quot*es'            cs'"            "change quotes"
	-- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
	surround_change_arround = {
		function()
			vim.api.nvim_input("cs")
		end,
		"Change Arround",
	},
	-- delete(functi*on calls)     dsf             function calls
	surround_delete_function_call = {
		function()
			vim.api.nvim_input("dsf")
		end,
		"Delete Funtion Call",
	},
}
