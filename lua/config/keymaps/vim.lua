local Utils = require("nk.utils")

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>i")

-- Resize panel up
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
-- Resize panel down
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
-- Resize panel left
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
-- Resize panel right
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Select all text
vim.keymap.set("n", "<C-a>", "gg0vG$")
vim.keymap.set("i", "<C-a>", "<ESC>gg0vG$")

-- Open link
vim.keymap.set("n", "gx", function()
    local pattern =
    "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*\\})\\})+"
    local line = vim.api.nvim_get_current_line()

    local links = {}

    local link = ""
    local last = 0
    local first = 0
    while true do
        link, first, last = unpack(vim.fn.matchstrpos(line, pattern, last))
        link = vim.trim(link)
        if link == "" then
            break
        end
        table.insert(links, {
            link = link,
            first = first,
            last = last,
        })
    end

    local open_cmd = Utils.is_windows() and 'cmd.exe /c start ""' or "xdg-open"
    if #links > 0 then
        local col = vim.fn.col(".")
        for _, current_link in ipairs(links) do
            if col >= current_link.first and col <= current_link.last then
                vim.fn.jobstart(string.format("%s %s", open_cmd, current_link.link), {
                    on_stderr = function(_, data)
                        local msg = table.concat(data or {}, "\n")
                        if msg ~= "" then
                            Utils.notify_error("Error trying to open a link: " .. msg)
                        end
                    end,
                })
            end
        end
        return
    end
    Utils.notify("Link not found!")
end)

-- Move text up
vim.keymap.set("i", "<A-k>", "<ESC>:m .-2<CR>i")
-- Move text down
vim.keymap.set("i", "<A-j>", "<ESC>:m .+1<CR>i")

-- Indent left
vim.keymap.set("v", "<", "<gv")
-- Indent right
vim.keymap.set("v", ">", ">gv")

-- Paste
vim.keymap.set("v", "p", '"_dP')

-- Expand window up
vim.keymap.set("n", "<leader>k", "<cmd>wincmd k<CR>")
-- Expand window down
vim.keymap.set("n", "<leader>j", "<cmd>wincmd j<CR>")
-- Expand window left
vim.keymap.set("n", "<leader>h", "<cmd>wincmd h<CR>")
-- Expand window right
vim.keymap.set("n", "<leader>l", "<cmd>wincmd l<CR>")
