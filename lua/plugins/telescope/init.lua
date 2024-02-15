local Utils = require("user.utils")

local function get_telescope_config(themes, actions, undo)
    local keymaps = require("config.keymaps").telescope
    local icons = require("config.icons")
    return {
        defaults = {
            prompt_prefix = icons.prompt_prefix .. " ",
            selection_caret = icons.selection .. " ",
            path_display = { "smart" },
            file_ignore_patterns = {
                ".git/",
                "node_modules",
            },
            mappings = {
                i = {
                    [keymaps.move_selection_next] = actions.move_selection_next,
                    [keymaps.move_selection_next_2] = actions.move_selection_next,
                    [keymaps.move_selection_prev] = actions.move_selection_previous,
                    [keymaps.move_selection_prev_2] = actions.move_selection_previous,
                },
            },
        },
        pickers = {},
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            undo = {
                use_delta = true,
                use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
                side_by_side = false,
                diff_context_lines = vim.o.scrolloff,
                entry_format = "state #$ID, $STAT, $TIME",
                time_format = "",
                mappings = {
                    i = {
                        -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
                        -- you want to replicate these defaults and use the following actions. This means
                        -- installing as a dependency of telescope in it's `requirements` and loading this
                        -- extension from there instead of having the separate plugin definition as outlined
                        -- above.
                        [keymaps.undo_restore] = undo.restore,
                        [keymaps.undo_yank_additions] = undo.yank_additions,
                        [keymaps.undo_yank_deletions] = undo.yank_deletions,
                    },
                },
            },
            ["ui-select"] = {
                themes.get_dropdown(),
            },
        },
    }
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        "debugloop/telescope-undo.nvim",
        "nvim-telescope/telescope-ui-select.nvim"
    },
    event = "BufEnter",
    config = function()
        Utils.callback_if_ok_msg("telescope", function(telescope)
            local config = get_telescope_config(require("telescope.themes"), require("telescope.actions"),
                require("telescope-undo.actions"))
            telescope.setup(config)

            telescope.load_extension("fzf")
            telescope.load_extension("undo")
            telescope.load_extension("ui-select")
        end)
    end,
}
