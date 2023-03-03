local K = vim.keymap

-------------------- Normal ----------------------

-- Save file
K.set("n", "<C-s>", ":w<CR>")

-- TODO: Add this to which key.
-- Change between panels in window
--K.set("n", "<M-h>", "<C-w>h")
--K.set("n", "<M-j>", "<C-w>j")
--K.set("n", "<M-k>", "<C-w>k")
--K.set("n", "<M-l>", "<C-w>l")

-- Resize selected panel
K.set("n", "<C-Up>", ":resize +2<CR>")
K.set("n", "<C-Down>", ":resize -2<CR>")
K.set("n", "<C-Left>", ":vertical resize -2<CR>")
K.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- TODO: Add this to which key.
-- Swap buffers / Change window
--K.nmap("<S-l>", ":bnext<CR>")
--K.nmap("<S-h>", ":bprevious<CR>")

-- TODO: Add this to which key.
-- Split panel
--K.nmap("<C-L>", ":vsplit<CR>")
--K.nmap("<C-J>", ":split<CR>")

-- Move text up and down
K.set("n", "<A-j>", "<ESC>:m .+1<CR>")
K.set("n", "<A-k>", "<ESC>:m .-2<CR>")

-- Select text
K.set("n", "<C-a>", "ggVG")

-- Open link
-- TODO: Not sure if it is working, need to be checked, maybe move to which key.
K.set("n", "gx", ":silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>")

-------------------- Insert ----------------------

-- Fase escape from inset mode
K.set("i", "jk", "<ESC>")

-- Save file
K.set("i", "<C-s>", ":w<CR>")

-- Move text up and down
K.set("i", "<A-j>", "<ESC>:m .+1<CR><a>")
K.set("i", "<A-k>", "<ESC>:m .-2<CR><a>")

-------------------- Visual ----------------------

-- Stay in indent mode
K.set("v", "<", "<gv")
K.set("v", ">", ">gv")

-- Move text up and down
K.set("v", "<A-j>", ":m .+1<CR>==")
K.set("v", "<A-k>", ":m .-1<CR>==")

-- Better paste for visual mode
K.set("v", "p", '"_dP')

----------------- Visual Block -------------------

-- Move text up and down
K.set("x", "J", ":move '>+1<CR>gv-gv")
K.set("x", "K", ":move '<-2<CR>gv-gv")
K.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
K.set("x", "<A-k>", ":move '<-2<CR>gv-gv")
