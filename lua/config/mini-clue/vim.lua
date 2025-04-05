local Clue = require("nk.mini-clue")

Clue:nmap("<leader>L", "<cmd>vsplit<CR>", "Window Vertical Split")
Clue:nmap("<leader>J", "<cmd>split<CR>", "Window Horizontal Split")
Clue:nmap("<leader>B", "<cmd>b#<CR>", "Back to Buffer", "*", { "oil" })
Clue:nmap("<leader>k", "<cmd>wincmd k<CR>", "Change Window Up")
Clue:nmap("<leader>j", "<cmd>wincmd j<CR>", "Change Window Down")
Clue:nmap("<leader>h", "<cmd>wincmd h<CR>", "Change Window Left")
Clue:nmap("<leader>l", "<cmd>wincmd l<CR>", "Change Window Right")
