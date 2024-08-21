local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>s",
            group = "Search",
            buffer = true,
        },
        {
            "<leader>sd",
            "<cmd>lua require('plugins.nvim_tree.utils').find_directory_and_focus()<CR>",
            desc = "Directory",
            buffer = true,
        },
        {
            "<leader>e",
            "<cmd>lua require('plugins.nvim_tree.utils').nvim_tree_toggle()<CR>",
            buffer = true,
            hidden = true,
        },
    })
end

return M

