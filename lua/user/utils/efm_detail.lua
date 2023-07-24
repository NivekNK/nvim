local Utils = require("user.utils")

local details = {}
Utils.foreach_filename("/config/servers/@efm_detail", function(detail)
	local efm_detail = require("config.servers.@efm_detail." .. detail)
	details[detail] = efm_detail
end)

return details

