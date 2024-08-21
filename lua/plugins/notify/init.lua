local icons = require("config.icons")
local Utils = require("user.utils")

local config = {
	background_colour = "NormalFloat",
	fps = 30,
	icons = {
		DEBUG = icons.debug,
		ERROR = icons.error,
		INFO = icons.info,
		TRACE = icons.trace,
		WARN = icons.warning,
	},
	level = 2,
	minimum_width = 50,
	render = "wrapped-compact",
	stages = "fade_in_slide_out",
	timeout = 300,
	top_down = true,
}

return {
	"rcarriga/nvim-notify",
	lazy = false,
	priority = 900,
	config = function()
		Utils.callback_if_ok_msg("notify", function(notify)
			notify.setup(config)
			vim.notify = notify
		end)
	end,
}
