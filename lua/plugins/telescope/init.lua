local function get_telescope_config(actions)
local keymaps = require("config.keymaps").telescope
local icons = require("config.icons")
return {
    defaults = {
        prompt_prefix = icons.prompt_prefix .. " ",
        selection_caret = icons.selection ..  " ",
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
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
        },
    },
}
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    event = "BufEnter",
    config = function()
        local telescope_ok, telescope = pcall(require, "telescope")
        if not telescope_ok then
            vim.notify("Error loading telescope!", vim.log.levels.ERROR)
            return
        end

        local config = get_telescope_config(require("telescope.actions"))
        telescope.setup(config)

        telescope.load_extension("fzf")
    end,
}
