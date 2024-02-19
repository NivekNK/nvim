local utils = require("plugins.nvim_tree.utils")

return {
    toggle = { utils.nvim_tree_toggle },
    find_directory = { utils.find_directory_and_focus, "Directory" },
}
