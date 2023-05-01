return {
    find_files = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>",
        "Find Files"
    },
    live_grep = { "<cmd>Telescope live_grep theme=ivy<CR>", "Find Text" },
    buffers = { "<cmd>Telescope buffers<CR>", "Find Buffers" },
    changed_files = { "<cmd>Telescope git_status<CR>", "Changed Files" },
    branches = { "<cmd>Telescope git_branches<CR>", "Branches" },
    commit_history = { "<cmd>Telescope git_commits<CR>", "Commit History" }
}
