local commands = {}

commands.n = {
    save_file = ":w<CR>",
    resize_panel_up = ":resize +2<CR>",
    resize_panel_down = ":resize -2<CR>",
    resize_panel_left = ":vertical resize -2<CR>",
    resize_panel_right = ":vertical resize +2<CR>",
    move_text_up = "<ESC>:m .-2<CR>",
    move_text_down = "<ESC>: m .+1<CR>",
    select_all_text = "ggvG",
    -- TODO: Not sure if it is working, need to be checked, maybe move to which key.
    open_link = ":silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>",
}

commands.i = {
    escape_alternative = "<ESC>",
    save_file = "<ESC>:w<CR><i>",
    move_text_up = "<ESC>:m .-2<CR><a>",
    move_text_down = "<ESC>:m .+1<CR><a>",
}

commands.v = {
    indent_left = "<gv",
    indent_right = ">gv",
    move_text_up = ":m .-1<CR>==",
    move_text_down = ":m .+1<CR>==",
    better_paste = '"_dP',
}

commands.x = {
    move_text_up = ":move '<-2<CR>gv-gv",
    move_text_down = ":move '>+1<CR>gv-gv",
}

return commands
