local Utils = require("user.utils")

local ok, wk = pcall(require, "which-key")
if not ok then
    Utils.notify_error("at user.mappings could not find which-key!")
    return
end

wk.add({
    {
        "<leader>k",
        "<cmd>wincmd k<CR>",
        hidden = true,
    },
    {
        "<leader>j",
        "<cmd>wincmd j<CR>",
        hidden = true,
    },
    {
        "<leader>h",
        "<cmd>wincmd h<CR>",
        hidden = true,
    },
    {
        "<leader>l",
        "<cmd>wincmd l<CR>",
        hidden = true,
    },
    {
        "<leader>L",
        "<cmd>vsplit<CR>",
        desc = "Window Vertical Split"
    },
    {
        "<leader>J",
        "<cmd>split<CR>",
        desc = "Window Horizontal Split"
    },
    {
        "<cmd>b#<CR>",
        desc = "Back to Buffer",
    },
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        wk.add({
            {
                "<leader>f",
                "<cmd>NKFormat<CR>",
                desc = "Format",
                cond = function()
                    return Utils.check_filetype("modifiable-file")
                end,
            },
        })
    end
})

Utils.foreach_filename("plugins", function(plugin_name)
    Utils.callback_if_ok("plugins." .. plugin_name .. ".which_key", function(plugin)
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                plugin.setup(wk)
            end
        })
    end)
end, nil, true, true)
