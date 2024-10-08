local Utils = require("user.utils")

vim.api.nvim_create_user_command("NKToggleSpace", function()
    vim.cmd("set list!")
end, { desc = "Toggle between showing space characters or not." })

vim.api.nvim_create_user_command("Q", "q", { desc = "Quit for dummies." })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(_)
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.cmd([[noh]])
        vim.fn.setpos(".", save_cursor)
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*" },
    callback = function(_)
        local filetypes = {
            "asciidoc",
            "gitcommit",
            "latex",
            "mail",
            "markdown",
            "rst",
            "tex",
            "text",
        }

        if Utils.check_filetype(filetypes) then
            vim.cmd("setlocal spell")
        end
    end,
})

vim.api.nvim_create_user_command("NKToggleSpell", function()
    vim.cmd("setlocal spell!")
end, { desc = "Toggle spell checking!" })

