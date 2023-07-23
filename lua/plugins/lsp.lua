local keymaps = require("config.keymaps").lsp
local icons = require("config.icons")
local Utils = require("user.utils")

local neodev_config = {
	library = {
		enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
		-- these settings will be used for your Neovim config directory
		runtime = true, -- runtime path
		types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
		plugins = true, -- installed opt or start plugins in packpath
		-- you can also specify the list of plugins to make available as a workspace library
		-- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
	},
	setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
	-- for your Neovim config directory, the config.library settings will be used as is
	-- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
	-- for any other directory, config.library.enabled will be set to false
	-- override = function(root_dir, options) end,
	override = nil,
	-- With lspconfig, Neodev will automatically setup your lua-language-server
	-- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
	-- in your lsp start options
	lspconfig = true,
	-- much faster, but needs a recent built of lua-language-server
	-- needs lua-language-server >= 3.6.0
	pathStrict = true,
}

local function get_lspsaga_config()
	return {
		ui = {
			border = "rounded", -- Border type, see :help nvim_open_win
			devicon = true, -- Whether to use nvim-web-devicons
			title = true, -- Show title in some float window
			expand = icons.tree_expanded, -- Expand icon
			collapse = icons.tree_collapsed, -- Collapse icon
			code_action = icons.action, -- Code action icon
			actionfix = icons.action_fix .. " ", -- Action fix icon
			lines = { "┗", "┣", "┃", "━", "┏" }, -- Symbols used in virtual text connect
			kind = nil, -- LSP kind custom table
			imp_sign = icons.implement .. " ", -- Implement icon
		},
		hover = {
			max_width = 0.9, -- defines float window width
			max_height = 0.8, -- defines float window height
			open_link = nil, -- key for opening links
			open_cmd = nil, -- cmd for opening links
		},
		diagnostic = {
			show_code_action = true, -- Show code action in diagnostic jump window. It’s useful. Suggested to set to true
			show_layout = "float", -- Config layout of diagnostic window not jump window
			show_normal_height = 10, -- Show window height when diagnostic show window layout is normal
			jump_num_shortcut = true, -- Enable number shortcuts to execute code action quickly
			max_width = 0.8, -- Diagnostic jump window max width
			max_height = 0.6, -- Diagnostic jump window max height
			max_show_width = 0.9, -- Show window max width when layout is float
			max_show_height = 0.6, -- Show window max height when layout is float
			text_hl_follow = true, -- Diagnostic jump window text highlight follow diagnostic type
			border_follow = true, -- Diagnostic jump window border follow diagnostic type
			extend_relatedInformation = false, -- When have relatedInformation, diagnostic message is extended to show it
			diagnostic_only_current = false, -- Only show diagnostic virtual text on the current line
			keys = {
				-- exec_action = 'o', -- execute action (in jump window)
				quit = keymaps.saga.quit, -- quit key for the jump window
				toggle_or_jump = keymaps.saga.accept, -- toggle or jump to position when in diagnostic_show window
				quit_in_show = keymaps.saga.quit, -- quit key for the diagnostic_show window
			},
		},
		code_action = {
			num_shortcut = true, -- true whether number shortcut for code actions are enabled
			show_server_name = true, -- show language server name
			extend_gitsigns = true, -- extend gitsigns plugin diff action
			keys = {
				quit = keymaps.saga.quit, -- quit the float window
				exec = keymaps.saga.accept, -- execute action
			},
		},
		lightbulb = {
			enable = true, -- enable
			sign = false, -- show sign in status column
			debounce = 10, -- debounce
			sign_priority = 40, -- sign priority
			virtual_text = true, -- show virtual text at the end of line
		},
		scroll_preview = {
			scroll_down = keymaps.saga.scroll_down,
			scroll_up = keymaps.saga.scroll_up,
		},
		request_timeout = 2000,
		finder = {
			max_height = 0.5, -- max_height of the finder window (float layout)
			left_width = 0.3, -- Width of the left finder window (float layout)
			right_width = 0.5, -- Width of the right finder window (float layout)
			methods = {}, -- Keys are alias of LSP methods. Values are LSP methods, which you want show in finder. More info below
			-- For instance, methods = { 'tyd' = 'textDocument/typeDefinition' }
			default = "ref+imp", -- Default search results shown, ref for “references” and imp for “implementation”
			layout = "float", --  available value is normal and float
			-- normal will use the normal layout window priority is lower than command layout
			silent = false, -- If it’s true, it will disable show the no response message
			filter = {}, -- Keys are LSP methods. Values are a filter handler. Function parameter are client_id and result
			keys = {
				shuttle = keymaps.saga.finder.edit, -- shuttle bettween the finder layout window
				toggle_or_open = keymaps.saga.finder.definition, -- toggle expand or open
				vsplit = keymaps.saga.finder.vertical_split, -- open in vsplit
				split = keymaps.saga.finder.horizontal_split, -- open in split
				tabe = keymaps.saga.finder.tab, -- open in tabe
				tabnew = keymaps.saga.finder.new_tab, -- open in new tab
				quit = keymaps.saga.quit, -- quit the finder, only works in layout left window
				close = keymaps.saga.close, -- close finder
			},
		},
		definition = {
			width = 0.6, -- defines float window width
			height = 0.5, -- defines float window height
			keys = {
				edit = keymaps.saga.definition.edit,
				vsplit = keymaps.saga.definition.vertical_split,
				split = keymaps.saga.definition.horizontal_split,
				tabe = keymaps.saga.definition.tab,
				quit = keymaps.saga.quit,
				close = keymaps.saga.close,
			},
		},
		rename = {
			in_select = true, -- Default is true. Whether the name is selected when the float opens
			-- In some situation, just like want to change one or less characters, in_select is not so useful. You can tell the Lspsaga to start in normal mode using an extra argument like :Lspsaga lsp_rename mode=n
			auto_save = false, -- Auto save file when the rename is done
			project_max_width = 0.5, -- Width for the project_replace float window
			project_max_height = 0.5, -- Height for the project_replace float window
			keys = {
				quit = keymaps.saga.close,
				exec = keymaps.saga.accept,
				select = keymaps.saga.rename.select,
			},
		},
		symbol_in_winbar = {
			enable = true, -- Enable
			separator = " " .. icons.breadcrumb .. " ", -- Separator symbol
			hide_keyword = false, -- when true some symbols like if and for will be ignored (need treesitter)
			show_file = false, -- Show file name before symbols
			folder_level = 1, -- Show how many folder layers before the file name
			color_mode = true, -- true mean the symbol name and icon have same color. Otherwise, symbol name is light-white
			dely = 300, -- Dynamic render delay
		},
		-- outline = {
		--     win_position = 'right', -- window position
		--     win_width = 30, -- window width
		--     auto_preview = true, -- auto preview when cursor moved in outline window
		--     detail = true, -- show detail
		--     auto_close = true, -- auto close itself when outline window is last window
		--     close_after_jump = false, -- close after jump
		--     layout = 'normal', -- float or normal default is normal when is float above options will ignored
		--     max_height = 0.5, -- height of outline float layout
		--     left_width = 0.3, -- width of outline float layout left window
		--     keys = {
		--         toggle_or_jump = 'o', -- toggle or jump
		--         quit = 'q', -- quit outline window
		--         jump = 'e', --  jump to pos even on a expand/collapse node
		--     },
		-- },
		-- callhierarchy = {
		--     layout = 'float',
		--     keys = {
		--         edit = 'e',
		--         vsplit = 's',
		--         split = 'i',
		--         tabe = 't',
		--         close = '<C-c>k',
		--         quit = 'q',
		--         shuttle = '[w',
		--         toggle_or_req = 'u',
		--     },
		-- },
		implement = {
			enable = true,
			sign = true,
			lang = require("user.utils.servers").lang(),
			virtual_text = true,
			priority = 100,
		},
		beacon = {
			enable = true,
			frequency = 7,
		},
	}
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"RRethy/vim-illuminate",
		"b0o/schemastore.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"folke/neodev.nvim",
		{
			"nvimdev/lspsaga.nvim",
			event = "LspAttach",
			dependencies = {
				{
					"nvim-tree/nvim-web-devicons",
					event = "VeryLazy",
				},
				"nvim-treesitter/nvim-treesitter",
			},
		},
	},
	config = function()
		Utils.callback_if_ok_msg("neodev", function(neodev)
			neodev.setup(neodev_config)
		end)

		local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_ok then
			vim.notify("[plugins.lsp] Error >> lspconfig not found!", vim.log.levels.ERROR)
			return
		end

		local on_attach = function(client, buffer)
			-- Format filter
			-- if Utils.formatter.configured(client.name) then
			-- 	client.server_capabilities.document_formatting = false
			--
			-- 	vim.api.nvim_buf_create_user_command(buffer, "NKFormat", function()
			-- 		vim.cmd("Format")
			-- 		print("File formated!")
			-- 	end, { desc = "Format the current buffer." })
			--
			-- 	vim.api.nvim_buf_create_user_command(buffer, "NKFormatWrite", function()
			-- 		vim.cmd("FormatWrite")
			-- 		print("File formated!")
			-- 	end, { desc = "Format the current buffer and save." })
			-- else
			vim.api.nvim_buf_create_user_command(buffer, "NKFormat", function()
				vim.lsp.buf.format({ async = true })
				print("File formated!")
			end, { desc = "Format the current buffer." })

			vim.api.nvim_buf_create_user_command(buffer, "NKFormatWrite", function()
				vim.lsp.buf.format({ async = true })
				vim.cmd("w")
				print("File formated!")
			end, { desc = "Format the current buffer and save." })
			-- end

			vim.keymap.set("n", keymaps.declaration, vim.lsp.buf.declaration, { buffer = buffer })
			vim.keymap.set("n", keymaps.signature_help, vim.lsp.buf.signature_help, { buffer = buffer })
			vim.keymap.set("n", keymaps.references, vim.lsp.buf.references, { buffer = buffer })
			vim.keymap.set("n", keymaps.setloclist, vim.diagnostic.setloclist, { buffer = buffer })

			if not Utils.require_check("lspsaga") then
				-- Buffer keymaps
				vim.keymap.set("n", keymaps.implementation, vim.lsp.buf.implementation, { buffer = buffer })
				vim.keymap.set("n", keymaps.definition, vim.lsp.buf.definition, { buffer = buffer })
				vim.keymap.set("n", keymaps.hover, vim.lsp.buf.hover, { buffer = buffer })
				vim.keymap.set("n", keymaps.diagnostics, function()
					vim.diagnostic.open_float({ border = "rounded" })
				end, { buffer = buffer })
				vim.keymap.set("n", keymaps.goto_prev_diagnostic, function()
					vim.diagnostic.goto_next({ border = "rounded" })
				end, { buffer = buffer })
				vim.keymap.set("n", keymaps.goto_next_diagnostic, function()
					vim.diagnostic.goto_next({ border = "rounded" })
				end, { buffer = buffer })
			end

			Utils.callback_if_ok_msg("illuminate", function(illuminate)
				illuminate.on_attach(client)
			end)
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		Utils.callback_if_ok_msg("cmp_nvim_lsp", function(cmp_nvim_lsp)
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end)

		-- To make folding available
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		for _, server in pairs(require("user.utils.servers").lsp()) do
			if server ~= "ignore" then
				local opts = {
					on_attach = on_attach,
					capabilities = capabilities,
				}

				local custom = Utils.callback_if_ok("config.servers." .. server, function(custom)
					if type(custom.opts) == "table" then
						opts = vim.tbl_deep_extend("force", opts, custom.opts)
					elseif type(custom.opts) == "function" then
						opts = vim.tbl_deep_extend("force", opts, custom.opts())
					elseif custom.opts ~= "ignore" then
						vim.notify(
							"[lspconfig] Error >> server.opts should be a table, a function that returns a table or 'ignore' for: "
								.. server
								.. "!",
							vim.log.levels.ERROR
						)
					end
				end)

				if custom.setup then
					custom.setup(opts)
				else
					lspconfig[server].setup(opts)
				end
			end
		end

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			width = 60,
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			width = 60,
		})

		Utils.callback_if_ok_msg("lspsaga", function(lspsaga)
			lspsaga.setup(get_lspsaga_config())

			vim.keymap.set("n", keymaps.finder, "<cmd>Lspsaga lsp_finder<CR>")
			vim.keymap.set("n", keymaps.code_action, "<cmd>Lspsaga code_action<CR>")
			vim.keymap.set("n", keymaps.rename, "<cmd>Lspsaga rename ++project<CR>")
			vim.keymap.set("n", keymaps.definition, "<cmd>Lspsaga goto_definition<CR>")
			vim.keymap.set("n", keymaps.peek_definition, "<cmd>Lspsaga peek_definition<CR>")
			vim.keymap.set("n", keymaps.type_definition, "<cmd>Lspsaga peek_type_definition<CR>")
			vim.keymap.set("n", keymaps.hover, "<cmd>Lspsaga hover_doc<CR>")
			vim.keymap.set("n", keymaps.diagnostics, "<cmd>Lspsaga show_line_diagnostics<CR>")
			vim.keymap.set("n", keymaps.goto_prev_diagnostic, "<cmd>Lspsaga diagnostic_jump_prev<CR>")
			vim.keymap.set("n", keymaps.goto_next_diagnostic, "<cmd>Lspsaga diagnostic_jump_next<CR>")
			vim.keymap.set("n", keymaps.implementation, "<cmd>Lspsaga finder imp<CR>")
		end)
	end,
}
