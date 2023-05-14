local K = {}

K.n = {
    save_file = "<C-s>",
    resize_panel_up = "<C-Up>",
    resize_panel_down = "<C-Down>",
    resize_panel_left = "<C-Left>",
    resize_panel_right = "<C-Right>",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
    select_all_text = "<C-a>",
    open_link = "gx",
}

K.i = {
    escape_alternative = "jk",
    save_file = "<C-s>",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
}

K.v = {
    indent_left = "<",
    indent_right = ">",
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
    better_paste = "p",
}

K.x = {
    move_text_up = "<A-k>",
    move_text_down = "<A-j>",
}

K.neo_tree = {
    toggle_node = "<Space>",
    open = "<CR>",
    open_secondary = "<2-LeftK.use>",
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
    git_next_modified = "]g",
}

K.mason = {
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
    apply_language_filter = "<C-f>",
}

K.lsp = {
    declaration = "gD",
    definition = "gd",
    hover = "K",
    implementation = "gi",
    signature_help = "<C-k>",
    references = "gr",
    open_float = "gl",
    goto_prev = "[d",
    goto_next = "]d",
    setloclist = "<A-q>",
}

K.cmp = {
    select_prev_item = "<C-k>",
    select_next_item = "<C-j>",
    scroll_down = "<C-b>",
    scroll_up = "<C-f>",
    insert_mode_complete = "<C-Space>",
    abort_and_close = "<C-e>",
    confirm = "<CR>",
    super_autocomplete = "<Tab>",
    prev_super_autocomplete = "<S-Tab>",
}

K.illuminate = {
    next_reference = "<A-n>",
    prev_reference = "<A-p>",
}

K.treesitter = {
    autopairs_fast_wrap = "<A-e>",
}

K.telescope = {
    move_selection_next = "<Down>",
    move_selection_next_2 = "<C-j>",
    move_selection_prev = "<Up>",
    move_selection_prev_2 = "<C-k>",
}

K.comment = {
    toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
    },
}

K.toggleterm = {
    open_terminal = [[<c-\>]],
    exit_terminal = "jk",
    exit_terminal_2 = "<ESC>",
    select_left_panel = "<C-h>",
    select_right_panel = "<C-l>",
    select_up_panel = "<C-k>",
    select_down_panel = "<C-j>",
}

K.which_key = {
    scroll_down = "<C-j>", -- binding to scroll down inside the popup
    scroll_up = "<C-k>", -- binding to scroll up inside the popup
}

K.ufo = {
    scroll_up = "<C-k>",
    scroll_down = "<C-j>",
    jump_top = "[",
    jump_bottom = "]",
}

return K
