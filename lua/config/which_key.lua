local W = {}

W.vim = {
    move_to_panel_up = "k",
    move_to_panel_down = "j",
    move_to_panel_left = "h",
    move_to_panel_right = "l",
    window_vertical_split = "L",
    window_horizontal_split = "J",
    format = "f",
    back_to_buffer = "b",
}

W.neo_tree = {
    toggle_explorer = "e",
}

W.telescope = {
    {
        name = "Search",
        keymap = "s",
        mappings = {
            find_files = "f",
            live_grep = "t",
            buffers = "b",
            undo = "u",
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
    {
        name = "LSP",
        keymap = "p",
        mappings = {
            lsp_references = "e",
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
            diff = "d",
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
    {
        name = "Surround Text",
        keymap = "t",
        mappings = {
            -- surr*ound_words             ysiw)           (surround_words)
            surround_word = "w",
            -- *make strings               ys$"            "make strings"
            surround_to_end = "e",
            -- [delete ar*ound me!]        ds]             delete around me!
            surround_delete_arround = "d",
            -- remove <b>HTML t*ags</b>    dst             remove HTML tags
            surround_delete_html_tags = "h",
            -- 'change quot*es'            cs'"            "change quotes"
            -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
            surround_change_arround = "c",
            -- delete(functi*on calls)     dsf             function calls
            surround_delete_function_call = "f",
        }
    }
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
    open_trouble = "1"
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

W.markdown = {
    preview = "v",
}

W.lsp = {
    {
        name = "LSP",
        keymap = "p",
        mappings = {
            declaration = "d",
            peek_definition = "p",
            code_action = "a",
            rename = "r",
        },
    }
}

W.copilot = {
    toggle_copilot = "o",
}

W.harpoon = {
    toggle_marks = "m",
    add_mark = "M",
    marks_prev = ",",
    marks_next = ".",
}

return W
