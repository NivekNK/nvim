local neodev_config = {
    library = {
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true -- installed opt or start plugins in packpath
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

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
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

            -- Buffer keymaps
            local keymaps = require("config.keymaps").lsp
            vim.keymap.set("n", keymaps.declaration, vim.lsp.buf.declaration, { buffer = buffer })
            vim.keymap.set("n", keymaps.definition, vim.lsp.buf.definition, { buffer = buffer })
            vim.keymap.set("n", keymaps.hover, vim.lsp.buf.hover, { buffer = buffer })
            vim.keymap.set("n", keymaps.implementation, vim.lsp.buf.implementation, { buffer = buffer })
            vim.keymap.set("n", keymaps.signature_help, vim.lsp.buf.signature_help, { buffer = buffer })
            vim.keymap.set("n", keymaps.references, vim.lsp.buf.references, { buffer = buffer })
            vim.keymap.set("n", keymaps.open_float, function()
                vim.diagnostic.open_float({ border = "rounded" })
            end, { buffer = buffer })
            vim.keymap.set("n", keymaps.goto_prev, function()
                vim.diagnostic.goto_next({ border = "rounded" })
            end, { buffer = buffer })
            vim.keymap.set("n", keymaps.goto_next, function()
                vim.diagnostic.goto_next({ border = "rounded" })
            end, { buffer = buffer })
            vim.keymap.set("n", keymaps.setloclist, vim.diagnostic.setloclist, { buffer = buffer })

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

        for _, server in pairs(require("config.servers")) do
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities
            }

            local has_custom, custom = pcall(require, "config.servers." .. server)
            if has_custom then
                opts = vim.tbl_deep_extend("force", opts, custom.opts)
            end

            if custom.setup then
                custom.setup(opts)
            else
                lspconfig[server].setup(opts)
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
    end,
}
