M = {}

M.n = {
    save_file = "<C-s>",
    resize_panel_up = "<C-Up>",
    resize_panel_down = "<C-Down>",
    resize_panel_left = "<C-Left>",
    resize_panel_right = "<C-Right>",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
    select_all_text = "<C-a>",
    open_link = "gx"
}

M.i = {
    escape_alternative = "jk",
    save_file = "<C-s>",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>"
}

M.v = {
    indent_left = "<",
    indent_right = ">",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
    better_paste = "p"
}

M.x = {
    move_text_up = "<A-k>",
    move_text_down = "<A-j>"
}

M.neo_tree = {
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
--[=====[
M.mason = {
    -- Keymap to expand a package
    toggle_package_expand = "<CR>",
    -- Keymap to install the package under the current cursor position
    install_package = "i",
    -- Keymap to reinstall/update the package under the current cursor position
    update_package = "u",
    -- Keymap to check for new version for the package under the current cursor position
    check_package_version = "c",
    -- Keymap to update all installed packages
    update_all_packages = "U",
    -- Keymap to check which installed packages are outdated
    check_outdated_packages = "C",
    -- Keymap to uninstall a package
    uninstall_package = "X",
    -- Keymap to cancel a package installation
    cancel_installation = "<C-c>",
    -- Keymap to apply language filter
    apply_language_filter = "<C-f>"
}

M.lsp = {
    declaration = "gD",
    definition = "gd",
    hover = "K",
    implementation = "gi",
    signature_help = "<C-k>",
    references = "gr",
    open_float = "gl",
    goto_prev = "[d",
    goto_next = "]d",
    setloclist = "<leader>q"
}
--]=====]

return M
