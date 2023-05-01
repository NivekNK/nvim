local W = {}

W.vim = {
    move_to_panel_up = "k",
    move_to_panel_down = "j",
    move_to_panel_left = "h",
    move_to_panel_right = "l",
    window_previous = ",",
    window_next = ".",
    window_vertical_split = "L",
    window_horizontal_split = "J"
}

W.neo_tree = {
    toggle_explorer = "e"
}

W.telescope = {
    {
        name = "Find",
        keymap = "f",
        mappings = {
            find_files = "f",
            live_grep = "t",
            buffers = "b"
        }
    },
    {
        name = "Git",
        keymap = "g",
        mappings = {
            changed_files = "f",
            commit_history = "h",
            branches = "b"
        }
    }
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
            diff = "d"
        }
    }
}

return W
