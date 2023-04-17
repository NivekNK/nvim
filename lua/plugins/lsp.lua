return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig_ok, _ = pcall(require, "lspconfig")
        if not lspconfig_ok then
            vim.notify("Error loading lspconfig!", vim.log.levels.ERROR)
            return
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
