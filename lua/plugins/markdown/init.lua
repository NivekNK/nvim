return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install && git restore .",
    config = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
}
