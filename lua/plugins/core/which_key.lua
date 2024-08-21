local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>w",
            group = "Write Case",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>ws",
            "<cmd>Snek<CR>",
            desc = "snake_case",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>wp",
            "<cmd>Camel<CR>",
            desc = "PascalCase",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>wc",
            "<cmd>CamelB<CR>",
            desc = "camelCase",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>wk",
            "<cmd>Kebab<CR>",
            desc = "kebab-case",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
    })

    wk.add({
        {
            "<leader>r",
            group = "Surround",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- surr*ound_words             ysiw)           (surround_words)
        {
            "<leader>rw",
            function()
                vim.api.nvim_input("ysiw")
            end,
            desc = "Word",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- *make strings               ys$"            "make strings"
        {
            "<leader>re",
            function()
                vim.api.nvim_input("ys$")
            end,
            desc = "To End",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- *make strings               ys$"            "make strings"
        {
            "<leader>rs",
            function()
                vim.api.nvim_input("ys$\"")
            end,
            desc = "To String",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- [delete ar*ound me!]        ds]             delete around me!
        {
            "<leader>rd",
            function()
                vim.api.nvim_input("ds")
            end,
            desc = "Delete Arround",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- 'change quot*es'            cs'"            "change quotes"
        {
            "<leader>rc",
            function()
                vim.api.nvim_input("cs")
            end,
            desc = "Change Arround",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        {
            "<leader>rt",
            function()
                vim.api.nvim_input("cst")
            end,
            desc = "Change Tag",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file") and Utils.check_filetype({
                    "html",
                    "jsx",
                    "tsx",
                    "vue",
                    "astro",
                    "svelte",
                })
            end,
        },
    })
end

return M
