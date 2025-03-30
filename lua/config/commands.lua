vim.api.nvim_create_user_command("Q", "q", { desc = "Quit for dummies." })

-- Remove all trailing whitespace before saving file.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(args)
        -- Define an array of file types to exclude
        local excluded_filetypes = { "markdown" }

        -- Get the file type of the current buffer using the new API
        local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")

        -- Check if the file type is in the excluded list
        if vim.tbl_contains(excluded_filetypes, filetype) then
            return
        end

        -- Save the current cursor position
        local save_cursor = vim.fn.getpos(".")

        -- Remove trailing whitespace
        vim.cmd([[%s/\s\+$//e]])

        -- Clear search highlights
        vim.cmd([[noh]])

        -- Restore the cursor position
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Enable spell checking
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = {
        "*.adoc",
        "*.gitcommit",
        "*.tex",
        "*.mail",
        "*.md",
        "*.rst",
        "*.text",
        "*.txt",
    },
    callback = function()
        vim.cmd("setlocal spell") -- Enable spell checking for matching files
    end,
})
