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
            end
        }
    },
    config = function()
        local lspconfig_ok, _ = pcall(require, "lspconfig")
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

            -- Formatting user command
            vim.api.nvim_create_user_command("Format", function()
                vim.lsp.buf.format({ async = true })
            end, { desc = "Format the current buffer." })

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

        for _, server in pairs(require("config.servers")) do
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities
            }

            local has_custom, custom = pcall(require, "config.servers." .. server)
            if has_custom then
                opts = vim.tbl_deep_extend("force", opts, custom.opts)
            end

            if custom.server then
                custom.server(opts)
            else
                lspconfig[server].setup(opts)
            end
        end

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
            width = 60
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
            width = 60
        })
    end
}
