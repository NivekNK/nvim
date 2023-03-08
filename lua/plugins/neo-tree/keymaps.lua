M = {}

M.mappings = {
    toggle_node = "<Space>",
    open = "<CR>",
    open_secondary = "<2-LeftMouse>",
    open_with_window_picker = "w",
    open_horizontal_split = "S",
    open_vertical_split = "s",
    open_on_new_tab = "t",
    revert_preview = "<ESC>",
    toggle_preview = "P",
    focus_preview = "l",
    close_node = "C",
    close_all_nodes = "z",
    add_file = "n",
    add_directory = "a",
    delete = "d",
    buffer_delete = "bd",
    rename = "r",
    copy_to_clipboard = "y",
    cut_to_clipboard = "x",
    paste_from_clipboard = "p",
    copy = "c",
    move = "m",
    close_window = "q",
    refresh = "R",
    show_help = "?",
    prev_source = "<",
    next_source = ">",
    navigate_up = "<bs>", -- TODO: Change.
    set_as_root = ".",
    toggle_hidden = "H",
    git_prev_modified = "[g",
    git_next_modified = "]g"
}

M.which_key = {
    e = { "<cmd>Neotree toggle<CR>", "Explorer" }
}

return M
