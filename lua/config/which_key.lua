local W = {}

---@alias WhichKeyType "global"|"modifiable-buffer"|string|string[]

---@class WhichKeyKeymap
---@field keymap string
---@field filetype WhichKeyType

---@class WhichKeyTable
---@field filetype WhichKeyType
---@field keymaps table<string, WhichKeyKeymap|string>

---@class WhichKeySection
---@field name string
---@field filetype WhichKeyType
---@field keymap string
---@field child_keymaps table<string, WhichKeyKeymap|string>

-- NOTE: Use for WhichKeyArray declarations, where the values can be WhichKeyTable|WhichKeySection.
---@class WhichKeyArray
W.array = {}

---@type WhichKeyTable
W.vim = {
    filetype = "global",
    keymaps = {
        move_to_panel_up = "k",
        move_to_panel_down = "j",
        move_to_panel_left = "h",
        move_to_panel_right = "l",
        window_vertical_split = {
            filetype = "modifiable-buffer",
            keymap = "L",
        },
        window_horizontal_split = {
            filetype = "modifiable-buffer",
            keymap = "J",
        },
        format = {
            filetype = "modifiable-buffer",
            keymap = "f",
        },
        back_to_buffer = {
            filetype = "modifiable-buffer",
            keymap = "b",
        },
    }
}

---@type WhichKeyTable
W.neo_tree = {
    filetype = "global",
    keymaps = {
        toggle_explorer = "e",
    }
}

---@type WhichKeySection[]
W.telescope = {
    {
        name = "Search",
        keymap = "s",
        filetype = "global",
        child_keymaps = {
            find_files = "f",
            live_grep = "t",
            buffers = "b",
            undo = "u",
            keymaps = "k",
        },
    },
    {
        name = "Git",
        keymap = "g",
        filetype = "modifiable-buffer",
        child_keymaps = {
            changed_files = "f",
            commit_history = "h",
            branches = "b",
        },
    },
    {
        name = "LSP",
        keymap = "p",
        filetype = "modifiable-buffer",
        child_keymaps = {
            lsp_references = "e",
        }
    }
}

---@type WhichKeySection
W.git = {
    name = "Git",
    keymap = "g",
    filetype = "modifiable-buffer",
    child_keymaps = {
        next_hunk = "j",
        prev_hunk = "k",
        blame = "e",
        preview_hunk = "p",
        reset_hunk = "r",
        reset_buffer = "R",
        stage_hunk = "s",
        undo_stage_hunk = "u",
        diff = "d",
    }
}

---@type WhichKeyTable
W.hlslens = {
    filetype = "global",
    keymaps = {
        hide_highlights = "H",
    }
}

---@type WhichKeySection[]
W.core = {
    {
        name = "Write Case",
        keymap = "w",
        filetype = "modifiable-buffer",
        child_keymaps = {
            snake_case = "s",
            pascal_case = "p",
            camel_case = "c",
            kebab_case = "k",
        },
    },
    {
        name = "Surround Text",
        keymap = "t",
        filetype = "modifiable-buffer",
        child_keymaps = {
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

---@type WhichKeySection
W.yanky = {
    name = "Search",
    keymap = "s",
    filetype = "global",
    child_keymaps = {
        yank_history = "y",
    }
}

---@type WhichKeyTable
W.trouble = {
    filetype = "global",
    keymaps = {
        open_trouble = "1",
    }
}

---@type WhichKeySection
W.todo_comments = {
    name = "Comments",
    keymap = "c",
    filetype = "global",
    child_keymaps = {
        comments = {
            filetype = "modifiable-buffer",
            keymap = "c",
        },
        all_comments = "a",
        fix = "f",
        todo = "t",
        hack = "h",
        warn = "w",
        perf = "p",
        note = "n",
        test = "e",
    },
}

---@type WhichKeyTable
W.treesitter = {
    filetype = "modifiable-buffer",
    keymaps = {
        split_toggle = "S",
        go_to_context = "[",
    }
}

---@type WhichKeySection
W.color = {
    name = "Color",
    keymap = "C",
    filetype = "modifiable-buffer",
    child_keymaps = {
        color_picker = "p",
        toggle_color = {
            filetype = "global",
            keymap = "c",
        },
        -- lighten_color = "l",
        -- darken_color = "d",
        -- gradient_color = "g",
    }
}

---@type WhichKeyTable
W.markdown = {
    filetype = "markdown",
    keymaps = {
        preview = "v",
    }
}

---@type WhichKeySection
W.lsp = {
    name = "LSP",
    keymap = "p",
    filetype = "global",
    child_keymaps = {
        declaration = "d",
        peek_definition = "p",
        code_action = {
            filetype = "modifiable-buffer",
            keymap = "a",
        },
        rename = {
            filetype = "modifiable-buffer",
            keymap = "r",
        },
    }
}

---@type WhichKeyTable
W.copilot = {
    filetype = "global",
    keymaps = {
        toggle_copilot = "o",
    }
}

W.array.harpoon = {
    {
        filetype = "modifiable-buffer",
        keymaps = {
            toggle_marks = "m",
            add_mark = "M",
            marks_prev = ",",
            marks_next = ".",
        }
    },
    {
        name = "Search",
        keymap = "s",
        filetype = "global",
        child_keymaps = {
            marks = "m",
        }
    }
}

return W
