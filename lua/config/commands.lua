-- Create the command "NKFormat"
vim.api.nvim_create_user_command("NKFormat", function()
    vim.lsp.buf.format({ async = true })
    print("File formated!")
end, { desc = "Format the current buffer." })

-- Create the command "NKToggleSpace"
vim.api.nvim_create_user_command("NKToggleSpace", function()
    vim.cmd("set list!")
end, { desc = "Toggle between showing space characters or not." })

-- Clear all white space before a save file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(_)
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.cmd([[noh]])
        vim.fn.setpos(".", save_cursor)
    end,
})
