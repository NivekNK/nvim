local keymaps = require("config.keymaps").lsp
local icons = require("config.icons")
local Utils = require("user.utils")

local neodev_config = {
    library = {
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true, -- runtime path
        types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true  -- installed opt or start plugins in packpath
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

local lspsaga_config = {
    preview = {
        lines_above = 0,
        lines_below = 10,
    },
    scroll_preview = {
        scroll_down = keymaps.saga.scroll_down,
        scroll_up = keymaps.saga.scroll_up,
    },
    request_timeout = 2000,
    ui = {
        -- This option only works in Neovim 0.9
        title = true,
        -- Border type can be single, double, rounded, solid, shadow.
        border = "rounded",
        winblend = 0,
        expand = icons.tree_expanded,
        collapse = icons.tree_collapsed,
        code_action = icons.action,
        -- incoming = " ",
        -- outgoing = " ",
        hover = icons.hover .. " ",
        kind = {},
    },
    lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = false,
        sign_priority = 40,
        virtual_text = true,
    },
    beacon = {
               -- after jump from float window there will show beacon to remind you where the cursor is.
        enable = true,
        frequency = 7,
    },
    finder = {
        max_height = 0.5,
        min_width = 30,
        force_max_height = false,
        keys = {
            jump_to = keymaps.saga.finder.edit,
            expand_or_jump = keymaps.saga.finder.definition,
            vsplit = keymaps.saga.finder.vertical_split,
            split = keymaps.saga.finder.horizontal_split,
            tabe = keymaps.saga.finder.tab,
            tabnew = keymaps.saga.finder.new_tab,
            quit = keymaps.saga.quit,
            close_in_preview = keymaps.saga.quit,
        },
    },
    definition = {
        edit = keymaps.saga.definition.edit,
        vsplit = keymaps.saga.definition.vertical_split,
        split = keymaps.saga.definition.horizontal_split,
        tabe = keymaps.saga.definition.tab,
        quit = keymaps.saga.quit,
    },
    code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
            -- string | table type https://github.com/nvimdev/lspsaga.nvim#example-configuration
            quit = keymaps.saga.quit,
            exec = keymaps.saga.accept,
        },
    },
    hover = {
        max_width = 0.6,
    },
    diagnostic = {
        on_insert = false,
        on_insert_follow = false,
        insert_winblend = 0,
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        max_width = 0.7,
        max_height = 0.6,
        max_show_width = 0.9,
        max_show_height = 0.6,
        text_hl_follow = true,
        border_follow = true,
        extend_relatedInformation = false,
        keys = {
            -- exec_action = 'o',
            quit = keymaps.saga.quit,
            expand_or_jump = keymaps.saga.accept,
            quit_in_show = keymaps.saga.quit,
        },
    },
    rename = {
        quit = keymaps.saga.rename.quit,
        exec = keymaps.saga.accept,
        mark = keymaps.saga.rename.mark,
        confirm = keymaps.saga.accept,
        in_select = true,
    },
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
        "b0o/schemastore.nvim",
        {
            "hrsh7th/cmp-nvim-lsp",
            cond = function()
                local cmp_ok, _ = pcall(require, "cmp")
                return cmp_ok
            end,
        },
        {
            "folke/neodev.nvim",
            cond = function()
                local cmp_ok, _ = pcall(require, "cmp")
                return cmp_ok
            end,
        },
        {
            "glepnir/lspsaga.nvim",
            event = "LspAttach",
            dependencies = {
                {
                    "nvim-tree/nvim-web-devicons",
                    event = "VeryLazy",
                },
                "nvim-treesitter/nvim-treesitter",
            }
        }
    },
    config = function()
        local neodev_ok, neodev = pcall(require, "neodev")
        if neodev_ok then
            neodev.setup(neodev_config)
        else
            vim.notify("[lspconfig] Error loading neodev!", vim.log.levels.WARN)
        end

        local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
        if not lspconfig_ok then
            vim.notify("Error loading lspconfig!", vim.log.levels.ERROR)
            return
        end

        local on_attach = function(client, buffer)
            -- Format filter
            local null_ls_ok, null_ls = pcall(require, "null-ls")
            if null_ls_ok then
                local sources = require("null-ls.sources").get_available(vim.bo.filetype, null_ls.methods.FORMATTING)
                if #sources > 0 then
                    client.server_capabilities.document_formatting = false
                end
            else
                vim.notify("[lspconfig] Error loading null-ls!", vim.log.levels.WARN)
            end

            local navic_ok, navic = pcall(require, "nvim-navic")
            if navic_ok and client.server_capabilities["documentSymbolProvider"] then
                navic.attach(client, buffer)
            else
                vim.notify("[lspconfig] Error loading navic!", vim.log.levels.WARN)
            end

            vim.keymap.set("n", keymaps.declaration, vim.lsp.buf.declaration, { buffer = buffer })
            vim.keymap.set("n", keymaps.implementation, vim.lsp.buf.implementation, { buffer = buffer })
            vim.keymap.set("n", keymaps.signature_help, vim.lsp.buf.signature_help, { buffer = buffer })
            vim.keymap.set("n", keymaps.references, vim.lsp.buf.references, { buffer = buffer })
            vim.keymap.set("n", keymaps.setloclist, vim.diagnostic.setloclist, { buffer = buffer })

            local lspsaga_ok, _ = pcall(require, "lspsaga")
            if not lspsaga_ok then
                -- Buffer keymaps
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

            local illuminate_ok, illuminate = pcall(require, "illuminate")
            if illuminate_ok then
                illuminate.on_attach(client)
            else
                vim.notify("[lspconfig] Error loading illuminate!", vim.log.levels.WARN)
            end
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if cmp_nvim_lsp_ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        else
            vim.notify("[lspconfig] Error loading cmp_nvim_lsp!", vim.log.levels.WARN)
        end

        -- To make folding available
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        for _, server in pairs(require("user.utils.servers")) do
            if server ~= "ignore" then
                local opts = {
                    on_attach = on_attach,
                    capabilities = capabilities
                }

                local custom = Utils.callback_if_ok("config.servers." .. server, function(custom)
                    if type(custom.opts) == "table" then
                        opts = vim.tbl_deep_extend("force", opts, custom.opts)
                    elseif type(custom.opts) == "function" then
                        opts = vim.tbl_deep_extend("force", opts, custom.opts())
                    elseif custom.opts ~= "ignore" then
                        vim.notify(
                        "[lspconfig] Error >> server.opts should be a table, a function that returns a table or 'ignore' for: " ..
                        server .. "!", vim.log.levels.ERROR)
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

        vim.keymap.set("n", keymaps.format, "<cmd>NKFormat<CR>")

        local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
        if lspsaga_ok then
            lspsaga.setup(lspsaga_config)

            vim.keymap.set("n", keymaps.finder, "<cmd>Lspsaga lsp_finder<CR>")
            vim.keymap.set("n", keymaps.code_action, "<cmd>Lspsaga code_action<CR>")
            vim.keymap.set("n", keymaps.rename, "<cmd>Lspsaga rename<CR>")
            vim.keymap.set("n", keymaps.definition, "<cmd>Lspsaga goto_definition<CR>")
            vim.keymap.set("n", keymaps.peek_definition, "<cmd>Lspsaga peek_definition<CR>")
            vim.keymap.set("n", keymaps.type_definition, "<cmd>Lspsaga peek_type_definition<CR>")
            vim.keymap.set("n", keymaps.hover, "<cmd>Lspsaga hover_doc<CR>")
            vim.keymap.set("n", keymaps.diagnostics, "<cmd>Lspsaga show_line_diagnostics<CR>")
            vim.keymap.set("n", keymaps.goto_prev_diagnostic, "<cmd>Lspsaga diagnostic_jump_prev<CR>")
            vim.keymap.set("n", keymaps.goto_next_diagnostic, "<cmd>Lspsaga diagnostic_jump_next<CR>")
        else
            vim.notify("[lsp] Error loading lspsaga!", vim.log.levels.WARN)
        end
    end,
}
