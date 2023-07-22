local Utils = require("user.utils")

-- any, util
local function get_formatter_config(_)
	return {
		-- Enable or disable logging
		logging = true,
		-- Set the log level
		log_level = vim.log.levels.WARN,
		-- All formatter configurations are opt-in
		filetype = {
			-- Formatter configurations for filetype "lua" go here
			-- and will be executed in order
			-- lua = {
			--     -- "formatter.filetypes.lua" defines default configurations for the
			--     -- "lua" filetype
			--     require("formatter.filetypes.lua").stylua,
			--
			--     -- You can also define your own configuration
			--     function()
			--         -- Supports conditional formatting
			--         if util.get_current_buffer_file_name() == "special.lua" then
			--             return nil
			--         end
			--
			--         -- Full specification of configurations is down below and in Vim help
			--         -- files
			--         return {
			--             exe = "stylua",
			--             args = {
			--                 "--search-parent-directories",
			--                 "--stdin-filepath",
			--                 util.escape_path(util.get_current_buffer_file_path()),
			--                 "--",
			--                 "-",
			--             },
			--             stdin = true,
			--         }
			--     end
			-- },
			-- Use the special "*" filetype for defining formatter configurations on
			-- any filetype
			["*"] = {
				-- "formatter.filetypes.any" defines default configurations for any
				-- filetype
				-- any.remove_trailing_whitespace,
				function()
					return {
						exe = "sed",
						args = { "-i", '"s/[ \t]*$//"' },
						stdin = false,
					}
				end,
			},
		},
	}
end

return {
	"mhartington/formatter.nvim",
	config = function()
		Utils.callback_if_ok_msg("formatter", function(formatter)
			local config = get_formatter_config(require("formatter.util"))
			local config_filetype = require("user.utils.servers").formatter()
			config.filetype = vim.tbl_deep_extend("force", config_filetype, config.filetype)
			formatter.setup(config)
		end)
	end,
}
