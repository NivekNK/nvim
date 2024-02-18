local Utils = require("user.utils")

if not Utils.require_check("telescope") then
    return
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local cmake_tools = require("cmake-tools")

local commands = {
    ["Build"] = "CMakeBuild",
    ["Select Build Target"] = "CMakeSelectBuildTarget",
    ["Run"] = "CMakeRun",
    ["Select Launch Target"] = "CMakeSelectLaunchTarget",
    ["Select Configure Preset"] = "CMakeSelectConfigurePreset",
    ["Select Build Preset"] = "CMakeSelectBuildPreset",
    ["Select Build Type"] = "CMakeSelectBuildType",
    ["Select Kit"] = "CMakeSelectKit",
}

local cmake_commands = function(opts)
    local results = {
        "Build",
        "Select Build Target",
        "Run",
        "Select Launch Target",
    }

    if cmake_tools.has_cmake_preset() then
        table.insert(results, "Select Configure Preset")
        table.insert(results, "Select Build Preset")
    else
        table.insert(results, "Select Build Type")
        table.insert(results, "Select Kit")
    end

    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "CMake",
        finder = finders.new_table({
            results = results,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd(commands[selection[1]])
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("NKCMakeTelescope", function()
    if cmake_tools.is_cmake_project() then
        cmake_commands(require("telescope.themes").get_dropdown({}))
    end
end, { desc = "Open Telescope window for CMake commands." })
