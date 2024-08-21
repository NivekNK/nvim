local K = {}

K.n = {
    save_file = "<C-s>",
    resize_panel_up = "<C-Up>",
    resize_panel_down = "<C-Down>",
    resize_panel_left = "<C-Left>",
    resize_panel_right = "<C-Right>",
    select_all_text = "<C-a>",
    black_hole = "Q",
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
    better_paste = "p",
}

K.x = {}

K.lsp = {
    finder = "gh",
    code_action = "<Tab-e>",
    rename = "gR",
    declaration = "gD",
    peek_definition = "gp",
    definition = "gd",
    type_definition = "gt",
    hover = "K",
    implementation = "gi",
    signature_help = "<C-k>",
    references = "gr",
    diagnostics = "gl",
    goto_prev_diagnostic = "[d",
    goto_next_diagnostic = "]d",
    setloclist = "<A-q>",
    format = "fo",
    saga = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
        quit = { "q", "<ESC>" },
        close = "<C-c>k",
        accept = "<CR>",
        finder = {
            edit = "e",
            definition = "d",
            vertical_split = "s",
            horizontal_split = "S",
            tab = "t",
            new_tab = "r",
        },
        definition = {
            edit = "<C-c>e",
            vertical_split = "<C-c>s",
            horizontal_split = "<C-c>S",
            tab = "<C-c>t",
        },
        rename = {
            select = "x",
        },
    },
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
    undo_restore = "<CR>",
    undo_yank_additions = "<C-CR>",
    undo_yank_deletions = "<S-CR>",
    spell_suggestions = "z=",
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

K.which_key = {
    scroll_down = "<C-j>", -- binding to scroll down inside the popup
    scroll_up = "<C-k>",   -- binding to scroll up inside the popup
}

K.yanky = {
    paste_indent_right_after = ">P",
    paste_indent_left_after = "<P",
    paste_at_indent_after = "=P",
    paste_indent_right_before = ">p",
    paste_indent_left_before = "<p",
    paste_at_indent_before = "=p",
    telescope = {
        i = {
            paste_after = "<C-P>",
            paste_before = "<C-p>",
            delete = "<C-x>",
            register = "<C-r>",
        },
        n = {
            paste_after = "P",
            paste_before = "p",
            delete = "d",
            register = "r",
        },
    },
}

K.trouble = {
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q",                  -- close the list
    cancel = "<esc>",             -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r",                -- manually refresh
    jump = { "<CR>", "<Tab>" },   -- jump to the diagnostic or open / close folds
    open_split = { "<C-x>" },     -- open buffer in new split
    open_vsplit = { "<C-v>" },    -- open buffer in new vsplit
    open_tab = { "<C-t>" },       -- open buffer in new tab
    jump_close = { "o" },         -- jump to the diagnostic and close the list
    toggle_mode = "m",            -- toggle between "workspace" and "document" diagnostics mode
    toggle_preview = "P",         -- toggle auto_preview
    hover = "K",                  -- opens a small popup with the full multiline message
    preview = "p",                -- preview the diagnostic location
    close_folds = { "zM", "zm" }, -- close all folds
    open_folds = { "zR", "zr" },  -- open all folds
    toggle_fold = { "zA", "za" }, -- toggle fold of current file
    previous = "k",               -- previous item
    next = "j",                   -- next item
}

K.color = {
    close = "q",
    accept = "<CR>",
    toggle_alpha = "a",
    increase = ".",
    big_increase = ">",
    decrease = ",",
    big_decrease = "<",
    set_to_zero = "0",
    set_to_max = "=",
    toggle_output_mode = "o",
    toggle_input_mode = "i",
}

K.harpoon = {
    open_vertical_split = "<C-s>",
    open_horizontal_split = "<C-S>",
}

K.mini_move = {
    -- Move visual selection in Visual mode. Defajlts are Alt (Meta) + hjkl.
    left = "<A-h>",
    right = "<A-l>",
    down = "<A-j>",
    up = "<A-k>",

    -- Move current line in Normal mode
    line_left = "<A-h>",
    line_right = "<A-l>",
    line_down = "<A-j>",
    line_up = "<A-k>",
}

K.nvim_tree = {
    trash_file = "d",
    delete_file = "D",
    copy_file = "y",
    cut_file = "x",
    paste = "p",
    select_file = "h",
    move_file = "m",
    open = "<CR>",
    rename = "r",
    rename_omit_filename = "R",
    new_file = "n",
    copy_absolute_path = "ca",
    copy_relative_path = "cr",
    copy_filename = "cf",
    change_working_directory = "cd",
    open_horizontal_split = "S",
    open_vertical_split = "s",
}

return K
