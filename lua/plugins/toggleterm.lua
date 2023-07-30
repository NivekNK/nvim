local keymaps = require("config.keymaps").toggleterm
local Utils = require("user.utils")

local toggleterm_config = {
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.5
		else
			return 15
		end
	end,
	open_mapping = keymaps.open_terminal,
	-- on_create = fun(t: Terminal), -- function to run when the terminal is first created
	on_create = nil,
	-- on_open = fun(t: Terminal), -- function to run when the terminal opens
	on_open = nil,
	-- on_close = fun(t: Terminal), -- function to run when the terminal closes
	on_close = nil,
	-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
	on_stdout = nil,
	-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
	on_stderr = nil,
	-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
	on_exit = nil,
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
	highlights = {
		-- highlights which map to a highlight group name and a table of it's values
		-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
		-- Normal = {
		--     guibg = "<VALUE-HERE>",
		-- },
		-- NormalFloat = {
		--     link = 'Normal'
		-- },
		-- FloatBorder = {
		--     guifg = "<VALUE-HERE>",
		--     guibg = "<VALUE-HERE>",
		-- },
	},
	shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
	shading_factor = 2, -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
	persist_size = true,
	persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
	direction = "vertical", --[[ 'vertical' | 'horizontal' | 'tab' | 'float' ]]
	close_on_exit = true, -- close the terminal window when the process exits
	-- Change the default shell. Can be a string or a function returning a string
	shell = function()
		if Utils.is_windows() then
			return "pwsh -NoLogo"
		end
		return "zsh"
	end,
	auto_scroll = true, -- automatically scroll to the bottom on terminal output
	-- This field is only relevant if direction is set to 'float'
	float_opts = {
		-- The border key is *almost* the same as 'nvim_open_win'
		-- see :h nvim_open_win for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = "curved", --[[ 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open ]]
		-- like `size`, width and height can be a number or function which is passed the current terminal
		-- width = <value>,
		-- height = <value>,
		-- winblend = 0,
		-- zindex = <value>
	},
	winbar = {
		enabled = false,
		name_formatter = function(term) --  term: Terminal
			return term.name
		end,
	},
}

return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	config = function()
		Utils.callback_if_ok_msg("toggleterm", function(toggleterm)
			toggleterm.setup(toggleterm_config)

			vim.api.nvim_create_autocmd({ "TermOpen" }, {
				pattern = { "term://*" },
				callback = function(_)
					local opts = { buffer = 0 }
					vim.keymap.set("t", keymaps.exit_terminal, [[<C-\><C-n>]], opts)
					vim.keymap.set("t", keymaps.exit_terminal_2, [[<C-\><C-n>]], opts)
					vim.keymap.set("t", keymaps.select_left_panel, [[<Cmd>wincmd h<CR>]], opts)
					vim.keymap.set("t", keymaps.select_down_panel, [[<Cmd>wincmd j<CR>]], opts)
					vim.keymap.set("t", keymaps.select_up_panel, [[<Cmd>wincmd k<CR>]], opts)
					vim.keymap.set("t", keymaps.select_right_panel, [[<Cmd>wincmd l<CR>]], opts)
				end,
			})
		end)
	end,
}
