local Clue = require("nk.mini-clue")

Clue:nmap("<leader>L", "<cmd>vsplit<CR>", "Window Vertical Split")
Clue:nmap("<leader>J", "<cmd>split<CR>", "Window Horizontal Split")
Clue:nmap("<leader>B", "<cmd>b#<CR>", "Back to Buffer")
Clue:nmap("<leader>T", ":lua vim.notify('TEST')<CR>", "TEST", "*.lua")
