local K = vim.keymap

-------------------- Normal ----------------------

-- Save file
K.set("n", "<C-s>", ":w<CR>")

-- Resize selected panel
K.set("n", "<C-Up>", ":resize +2<CR>")
K.set("n", "<C-Down>", ":resize -2<CR>")
K.set("n", "<C-Left>", ":vertical resize -2<CR>")
K.set("n", "<C-Right>", ":vertical resize +2<CR>")

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
