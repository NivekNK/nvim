local Utils = require("user.utils")

local copilot_config = {
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 16.x
	server_opts_overrides = {},
}

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			Utils.callback_if_ok_msg("copilot", function(copilot)
				copilot_config = vim.tbl_deep_extend("force", copilot_config, {
					panel = { enabled = false },
					suggestion = { enabled = false },
				})
				copilot.setup(copilot_config)
                vim.cmd("Copilot disable")
			end)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			Utils.callback_if_ok_msg("copilot_cmp", function(copilot_cmp)
				copilot_cmp.setup()
			end)
		end,
	},
}
