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

return W
