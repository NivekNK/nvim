local Utils = require("user.utils")

local function get_statuscol_config(builtin)
	return {
		relculright = true,
		segments = {
			{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
			{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			{ text = { "%s" }, click = "v:lua.ScSa" },
		},
	}
end

return {
	"luukvbaal/statuscol.nvim",
	config = function()
		Utils.callback_if_ok_msg("statuscol", function(statuscol)
			local config = get_statuscol_config(require("statuscol.builtin"))
			statuscol.setup(config)
		end)
	end,
}
