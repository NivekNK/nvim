local W = {}

W.vim = {
    move_to_panel_up = "k",
    move_to_panel_down = "j",
    move_to_panel_left = "h",
    move_to_panel_right = "l",
    window_previous = ",",
    window_next = ".",
    window_vertical_split = "L",
    window_horizontal_split = "J",
}

W.neo_tree = {
    toggle_explorer = "e",
}

W.telescope = {
    {
        name = "Find",
        keymap = "f",
        mappings = {
            find_files = "f",
            live_grep = "t",
            buffers = "b",
        },
    },
    {
        name = "Git",
        keymap = "g",
        mappings = {
            changed_files = "f",
            commit_history = "h",
            branches = "b",
        },
    },
}

W.git = {
    {
        name = "Git",
        keymap = "g",
        mappings = {
            next_hunk = "j",
            prev_hunk = "k",
            blame = "e",
            preview_hunk = "p",
            reset_hunk = "r",
            reset_buffer = "R",
            stage_hunk = "s",
            undo_stage_hunk = "u",
            diff = "d",
        },
    },
}

W.cokeline = {
    {
        name = "Buffer",
        keymap = "b",
        mappings = {
            pick_focus = "f",
            pick_close = "c",
            pick_focus_at_1 = "1",
            pick_focus_at_2 = "2",
            pick_focus_at_3 = "3",
            pick_focus_at_4 = "4",
            pick_focus_at_5 = "5",
            pick_focus_at_6 = "6",
            pick_focus_at_7 = "7",
            pick_focus_at_8 = "8",
            pick_focus_at_9 = "9",
        },
    },
}

W.ufo = {
    {
        name = "Fold",
        keymap = "z",
        mappings = {
            open_all_folds = "o",
            close_all_folds = "c",
            peek_fold = "p",
        },
    },
}

W.hlslens = {
    hide_highlights = "H",
}

W.core = {
    {
        name = "Write Case",
        keymap = "w",
        mappings = {
            snake_case = "s",
            pascal_case = "p",
            camel_case = "c",
            kebab_case = "k",
        },
    },
}

W.yanky = {
    {
        name = "Search",
        keymap = "s",
        mappings = {
            yank_history = "y",
        },
    },
}

W.trouble = {
    open_trouble = "t"
}

W.todo_comments = {
    {
        name = "Comments",
        keymap = "c",
        mappings = {
            comments = "c",
            all_comments = "a",
            fix = "f",
            todo = "t",
            hack = "h",
            warn = "w",
            perf = "p",
            note = "n",
            test = "e",
        },
    },
}

W.treesitter = {
    split_toggle = "S",
    go_to_context = "[",
}

W.color = {
    {
        name = "Color",
        keymap = "C",
        mappings = {
            color_picker = "p",
            toggle_color = "c",
            lighten_color = "l",
            darken_color = "d",
            gradient_color = "g",
        },
    },
}

return W
