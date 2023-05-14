vim.api.nvim_create_user_command("NKf", function()
    vim.lsp.buf.format({ async = true })
    print("File formated!")
end, { desc = "Format the current buffer." })

vim.api.nvim_create_user_command("NKs", function()
    vim.cmd("set list!")
end, { desc = "Toggle between showing space characters or not." })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(_)
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.cmd([[noh]])
        vim.fn.setpos(".", save_cursor)
    end,
})
