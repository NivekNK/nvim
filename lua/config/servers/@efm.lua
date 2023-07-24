local efm = require("user.utils.efm_detail")

return {
	lua = {
        efm.stylua,
	},
	astro = {
        efm.eslint_d,
		efm.prettierd,
	},
	json = {
		efm.prettierd,
	},
	css = {
		efm.prettierd,
	},
	html = {
		efm.prettierd,
	},
	javascript = {
        efm.eslint_d,
		efm.prettierd,
	},
	javascriptreact = {
        efm.eslint_d,
		efm.prettierd,
	},
	typescript = {
        efm.eslint_d,
		efm.prettierd,
	},
	typescriptreact = {
        efm.eslint_d,
		efm.prettierd,
	},
}

