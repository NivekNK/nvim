local icons = require("config.icons")
local Utils = require("user.utils")

local lualine_config = {
	options = {
		icons_enabled = true,
		theme = "auto", -- lualine theme
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			-- Filetypes to disable lualine for.
			statusline = {}, -- only ignores the ft for statusline.
			winbar = {}, -- only ignores the ft for winbar.
		},
		ignore_focus = {}, -- If current filetype is in this list it'll
		-- always be drawn as inactive statusline
		-- and the last window will be drawn as active statusline.
		-- for example if you don't want statusline of
		-- your file tree / sidebar window to have active
		-- statusline you can add their filetypes here.

		always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
		-- can't take over the entire statusline even
		-- if neither of 'x', 'y' or 'z' are present.

		globalstatus = true, -- enable global statusline (have a single statusline
		-- at bottom of neovim instead of one for every window).
		-- This feature is only available in neovim 0.7 and higher.

		refresh = {
			-- sets how often lualine should refresh it's contents (in ms)
			statusline = 1000, -- The refresh option sets minimum time that lualine tries
			tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
			winbar = 1000, -- arises that lualine needs to refresh itself before this time
			-- it'll do it.

			-- Also you can force lualine's refresh by calling refresh function
			-- like require('lualine').refresh()
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str, _)
					return string.sub(str, 1, 1)
				end,
			},
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
            {
                function()
                    return vim.fn.expand("%:t")
                end,
                separator = { right = " " },
                cond = function()
                    local buffer = vim.fn.expand("%:t")
                    local disabled_filenames = {
                        "neo-tree",
                    }

                    if type(buffer) == "string" then
                        for _, str in ipairs(disabled_filenames) do
                            if string.find(buffer, str, 1, true) then
                                return false
                            end
                        end
                        return true
                    else
                        return false
                    end
                end,
            },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = {
					error = icons.error .. " ",
					warn = icons.warning .. " ",
				},
				colored = false,
				always_visible = true,
			},
		},
		lualine_x = {
			"encoding",
			{
				"filesize",
				separator = { left = " " },
			},
		},
		lualine_y = {
			{
				"filetype",
				colored = false,
			},
		},
		lualine_z = {
			{
				"location",
				padding = 0,
			},
		},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		Utils.callback_if_ok_msg("lualine", function(lualine)
			Utils.foreach_filename("plugins", function(plugin_name)
				Utils.callback_if_ok("plugins." .. plugin_name .. ".lualine", function(plugin_lualine)
					if plugin_lualine.lualine_a then
						for _, v in ipairs(plugin_lualine.lualine_a) do
							table.insert(lualine_config.sections.lualine_a, v)
						end
					end
					if plugin_lualine.lualine_b then
						for _, v in ipairs(plugin_lualine.lualine_b) do
							table.insert(lualine_config.sections.lualine_b, v)
						end
					end
					if plugin_lualine.lualine_c then
						for _, v in ipairs(plugin_lualine.lualine_c) do
							table.insert(lualine_config.sections.lualine_c, v)
						end
					end
					if plugin_lualine.lualine_x then
						for _, v in ipairs(plugin_lualine.lualine_x) do
							table.insert(lualine_config.sections.lualine_x, v)
						end
					end
					if plugin_lualine.lualine_y then
						for _, v in ipairs(plugin_lualine.lualine_y) do
							table.insert(lualine_config.sections.lualine_y, v)
						end
					end
					if plugin_lualine.lualine_z then
						for _, v in ipairs(plugin_lualine.lualine_z) do
							table.insert(lualine_config.sections.lualine_z, v)
						end
					end
				end)
			end, {}, true, true)

			lualine.setup(lualine_config)
		end)
	end,
}
