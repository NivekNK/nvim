local function setup()
    local status_ok, neo_tree = pcall(require, "neo-tree")
    if not status_ok then
        vim.notify("Error loading neo-tree!", vim.log.levels.ERROR)
        return
    end

    -- Remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    local icons = require("config.icons")
    local mappings = require("plugins.neo-tree.keymaps").mappings

    neo_tree.setup({
        -- If a user has a sources list it will replace this one.
        -- Only sources listed here will be loaded.
        -- You can also add an external source by adding it's name to this list.
        -- The name used here must be the same name you would use in a require() call.
        sources = {
            "filesystem",
            "buffers",
            "git_status"
        },
        add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
        auto_clean_after_session_restore = false, -- Automatically clean up broken neo-tree buffers saved in sessions.
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab.
        close_floats_on_escape_key = true,
        default_source = "filesystem",
        enable_diagnostics = true,
        enable_git_status = true,
        enable_modified_markers = true, -- Show markers for files with unsaved changes.
        enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
        git_status_async = true,
        git_status_async_options = {
            batch_size = 1000, -- how many lines of git status results to process at a time
            batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
            max_lines = 10000  -- How many lines of git status results to process. Anything after this will be dropped.
                               -- Anything before this will be used. The last items to be processed are the untracked files.
        },
        hide_root_node = false, -- Hide the root node.
        retain_hidden_root_indent = false, -- IF the root node is hidden, keep the indentation anyhow. 
                                           -- This is needed if you use expanders because they render in the indent.
        log_level = "info", -- "trace", "debug", "info", "warn", "error", "fatal"
        log_to_file = false, -- true, false, "/path/to/file.log", use :NeoTreeLogs to show the file
        open_files_in_last_window = true, -- false = open files in top left window
        popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
        resize_timer_interval = 500, -- in ms, needed for containers to redraw right aligned and faded content
                                     -- set to -1 to disable the resize timer entirely
                                     -- NOTE: this will speed up to 50 ms for 1 second following a resize
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil , -- use a custom function for sorting files and directories in the tree 
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
        use_default_mappings = true,
        source_selector = {
            winbar = false, -- toggle to show selector on winbar
            statusline = false, -- toggle to show selector on statusline
            show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
                                                   -- of the top visible node when scrolled down.
            tab_labels = { -- falls back to source_name if nil
                filesystem = " " .. icons.folder_group .. " Files ",
                buffers = " " .. icons.files .. " Buffers ",
                git_status = " " .. icons.git .. " Git ",
                diagnostics = " " .. icons.diagnostic .. " Diagnostics "
            },
            content_layout = "start", -- only with `tabs_layout` = "equal", "focus"
            --                start  : |/ 裡 bufname     \/...
            --                end    : |/     裡 bufname \/...
            --                center : |/   裡 bufname   \/...
            tabs_layout = "equal", -- start, end, center, equal, focus
            --             start  : |/  a  \/  b  \/  c  \            |
            --             end    : |            /  a  \/  b  \/  c  \|
            --             center : |      /  a  \/  b  \/  c  \      |
            --             equal  : |/    a    \/    b    \/    c    \|
            --             active : |/  focused tab    \/  b  \/  c  \|
            truncation_character = icons.truncation, -- character to use when truncating the tab label
            tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
            tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
            padding = 0, -- can be int or table
            -- padding = { left = 2, right = 0 },
            -- separator = "▕", -- can be string or table, see below
             separator = { left = "▏", right= "▕" },
            -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
            -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
            -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
            -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
            -- separator = "|",                                              -- ||  a  |  b  |  c  |...
            separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
            show_separator_on_edge = false,
            --                       true  : |/    a    \/    b    \/    c    \|
            --                       false : |     a    \/    b    \/    c     |
            highlight_tab = "NeoTreeTabInactive",
            highlight_tab_active = "NeoTreeTabActive",
            highlight_background = "NeoTreeTabInactive",
            highlight_separator = "NeoTreeTabSeparatorInactive",
            highlight_separator_active = "NeoTreeTabSeparatorActive"
        },
        --
        --event_handlers = {
        --    {
        --        event = "before_render",
        --        handler = function (state)
        --            -- add something to the state that can be used by custom components
        --        end
        --    },
        --    {
        --        event = "file_opened",
        --        handler = function(file_path)
        --            -- auto close
        --            require("neo-tree").close_all()
        --        end
        --    },
        --    {
        --        event = "file_opened",
        --        handler = function(file_path)
        --            -- clear search after opening a file
        --            require("neo-tree.sources.filesystem").reset_search()
        --        end
        --    },
        --    {
        --        event = "file_renamed",
        --        handler = function(args)
        --            -- fix references to file
        --           print(args.source, " renamed to ", args.destination)
        --        end
        --    },
        --    {
        --        event = "file_moved",
        --        handler = function(args)
        --            -- fix references to file
        --            print(args.source, " moved to ", args.destination)
        --        end
        --    },
        --    {
        --        event = "neo_tree_buffer_enter",
        --        handler = function()
        --            vim.cmd 'highlight! Cursor blend=100'
        --        end
        --    },
        --    {
        --        event = "neo_tree_buffer_leave",
        --        handler = function()
        --            vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
        --        end
        --    },
        --    {
        --        event = "neo_tree_window_before_open",
        --        handler = function(args)
        --            print("neo_tree_window_before_open", vim.inspect(args))
        --        end
        --    },
        --    {
        --        event = "neo_tree_window_after_open",
        --        handler = function(args)
        --            vim.cmd("wincmd =")
        --        end
        --    },
        --    {
        --        event = "neo_tree_window_before_close",
        --        handler = function(args)
        --            print("neo_tree_window_before_close", vim.inspect(args))
        --        end
        --    },
        --    {
        --        event = "neo_tree_window_after_close",
        --        handler = function(args)
        --            vim.cmd("wincmd =")
        --        end
        --    }
        --},
        default_component_configs = {
            container = {
                enable_character_fade = true,
                width = "100%",
                right_padding = 0
            },
            --diagnostics = {
            --    symbols = {
            --        hint = "H",
            --        info = "I",
            --        warn = "!",
            --        error = "X"
            --    },
            --    highlights = {
            --        hint = "DiagnosticSignHint",
            --        info = "DiagnosticSignInfo",
            --        warn = "DiagnosticSignWarn",
            --        error = "DiagnosticSignError"
            --    }
            --},
            indent = {
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = icons.file_tree_collapsed,
                expander_expanded = icons.file_tree_expanded,
                expander_highlight = "NeoTreeExpander"
            },
            icon = {
                folder_closed = icons.folder_closed,
                folder_open = icons.folder_open,
                folder_empty = icons.folder_empty,
                folder_empty_open = icons.folder_empty,
                -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                -- then these will never be used.
                default = "*",
                highlight = "NeoTreeFileIcon"
            },
            modified = {
                symbol = icons.item_modified,
                highlight = "NeoTreeModified"
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName"
            },
            git_status = {
                symbols = {
                    -- Change type
                    added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted   = icons.item_deleted,-- this can only be used in the git_status source
                    renamed   = icons.item_renamed,-- this can only be used in the git_status source
                    -- Status type
                    untracked = icons.git_untracked,
                    ignored   = icons.git_ignored,
                    unstaged  = icons.git_unstaged,
                    staged    = icons.git_staged,
                    conflict  = icons.git_conflict
                },
                align = "right"
            }
        },
        window = {
            position = "left", -- left, right, top, bottom, float, current
            width = 40, -- applies to left and right positions
            height = 15, -- applies to top and bottom positions
            auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
            popup = { -- settings that apply to float position only
                size = {
                    height = "80%",
                    width = "50%"
                },
                position = "50%" -- 50% means center it
                -- you can also specify border here, if you want a different setting from
                -- the global popup_border_style.
            },
            same_level = false, -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
            insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
                                -- "child":   Insert nodes as children of the directory under cursor.
                                -- "sibling": Insert nodes as siblings of the directory under cursor.
            -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
            -- You can also create your own commands by providing a function instead of a string.
            mapping_options = {
                noremap = true,
                nowait = true
            },
            mappings = {
                [mappings.toggle_node] = { 
                    "toggle_node", 
                    nowait = false -- disable `nowait` if you have existing combos starting with this char that you want to use 
                },
                [mappings.open] = "open",
                [mappings.open_secondary] = "open",
                [mappings.open_with_window_picker] = "open_with_window_picker",
                [mappings.open_horizontal_split] = "open_split",
                [mappings.open_vertical_split] = "open_vsplit",
                [mappings.open_on_new_tab] = "open_tabnew",
                [mappings.revert_preview] = "revert_preview",
                [mappings.toggle_preview] = {
                    "toggle_preview",
                    config = {
                        use_float = true
                    }
                },
                [mappings.focus_preview] = "focus_preview",
                -- ["S"] = "split_with_window_picker",
                -- ["s"] = "vsplit_with_window_picker",
                -- ["<cr>"] = "open_drop",
                -- ["t"] = "open_tab_drop",
                --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                [mappings.close_node] = "close_node",
                -- ['C'] = 'close_all_subnodes',
                [mappings.close_all_nodes] = "close_all_nodes",
                --["Z"] = "expand_all_nodes",
                [mappings.add_file] = { 
                    "add",
                    -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = "none" -- "none", "relative", "absolute"
                    }
                },
                [mappings.add_directory] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                [mappings.delete] = "delete",
                [mappings.rename] = "rename",
                [mappings.copy_to_clipboard] = "copy_to_clipboard",
                [mappings.cut_to_clipboard] = "cut_to_clipboard",
                [mappings.paste_from_clipboard] = "paste_from_clipboard",
                [mappings.copy] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                -- ["c"] = {
                --  "copy",
                --  config = {
                --    show_path = "none" -- "none", "relative", "absolute"
                --  }
                --}
                [mappings.move] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                [mappings.close_window] = "close_window",
                [mappings.refresh] = "refresh",
                [mappings.show_help] = "show_help",
                [mappings.prev_source] = "prev_source",
                [mappings.next_source] = "next_source"
            }
        },
        filesystem = {
            window = {
                mappings = {
                    [mappings.navigate_up] = "navigate_up",
                    [mappings.set_as_root] = "set_root",
                    [mappings.toggle_hidden] = "toggle_hidden",
                    -- ["/"] = "fuzzy_finder",
                    -- ["D"] = "fuzzy_finder_directory",
                    -- ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                    -- ["D"] = "fuzzy_sorter_directory",
                    -- ["f"] = "filter_on_submit",
                    -- ["<c-x>"] = "clear_filter",
                    [mappings.git_prev_modified] = "prev_git_modified",
                    [mappings.git_next_modified] = "next_git_modified"
                }
            },
            async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
                                           -- "always" means directory scans are always async.
                                           -- "never"  means directory scans are never async.
            scan_mode = "shallow", -- "shallow": Don't scan into directories to detect possible empty directory a priori
                                   -- "deep": Scan into directories to detect empty or grouped empty directories a priori.
            bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
            cwd_target = {
                sidebar = "tab",   -- sidebar is when position = left or right
                current = "window" -- current is when position = current
            },
            -- The renderer section provides the renderers that will be used to render the tree.
            --   The first level is the node type.
            --   For each node type, you can specify a list of components to render.
            --       Components are rendered in the order they are specified.
            --         The first field in each component is the name of the function to call.
            --         The rest of the fields are passed to the function as the "config" argument.
            filtered_items = {
                visible = true, -- when true, they will just be displayed differently than normal items
                force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
                show_hidden_count = false, -- when true, the number of hidden items in each folder will be shown as the last entry
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                  --"node_modules"
                },
                hide_by_pattern = { -- uses glob style patterns
                  --"*.meta",
                  --"*/src/*/tsconfig.json",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                  --".gitignored",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                  --".DS_Store",
                  --"thumbs.db"
                },
                never_show_by_pattern = { -- uses glob style patterns
                  --".null-ls_*",
                }
            },
            find_by_full_path_words = false,  -- `false` means it only searches the tail of a path.
                                              -- `true` will change the filter into a full path
                                              -- search with space as an implicit ".*", so
                                              -- `fi init`
                                              -- will match: `./sources/filesystem/init.lua
            group_empty_dirs = false, -- when true, empty folders will be grouped together
            search_limit = 50, -- max number of search results when using filters
            follow_current_file = false, -- This will find and focus the file in the active buffer every
                                         -- time the current file is changed while the tree is open.
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                                  -- in whatever position is specified in window.position
                                -- "open_current",  -- netrw disabled, opening a directory opens within the
                                                  -- window like netrw would, regardless of window.position
                                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = false -- This will use the OS level file watchers to detect changes
                                           -- instead of relying on nvim autocmd events.
        },
        buffers = {
            window = {
                mappings = {
                    [mappings.buffer_delete] = "buffer_delete",
                    [mappings.navigate_up] = "navigate_up",
                    [mappings.set_as_root] = "set_root"
                }
            },
            bind_to_cwd = true,
            follow_current_file = true, -- This will find and focus the file in the active buffer every
                                        -- time the current file is changed while the tree is open.
            group_empty_dirs = true -- when true, empty folders will be grouped together
        },
        git_status = {
            window = {
                mappings = {
                    -- ["A"]  = "git_add_all",
                    -- ["gu"] = "git_unstage_file",
                    -- ["ga"] = "git_add_file",
                    -- ["gr"] = "git_revert_file",
                    -- ["gc"] = "git_commit",
                    -- ["gp"] = "git_push",
                    -- ["gg"] = "git_commit_and_push",
                }
            }
        }
    })
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- "s1n7ax/nvim-window-picker" TODO: Configure later
    },
    config = setup
}
