local Utils = require("user.utils")

if not Utils.require_check("telescope") then
    return
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local harpoon = require("harpoon")

local function harpoon_search_marks(opts)
    local file_paths = {}
    for _, item in ipairs(harpoon:list().items) do
        table.insert(file_paths, item.value)
    end

    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Marks",
        finder = finders.new_table({
            results = file_paths,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selected_path = action_state.get_selected_entry()[1]
                vim.cmd("e " .. selected_path)
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("NKHarpoonMarksTelescope", function()
    harpoon_search_marks(require("telescope.themes").get_dropdown({}))
end, { desc = "Open Telescope window for Harpoon marks." })
