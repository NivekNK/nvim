return {
    find_files = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
        "Files",
    },
    live_grep = { "<cmd>Telescope live_grep theme=ivy<CR>", "Text" },
    buffers = {
        "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false, layout_config = { height = 8 } }))<CR>",
        "Buffers",
    },
    changed_files = { "<cmd>Telescope git_status<CR>", "Changed Files" },
    branches = { "<cmd>Telescope git_branches<CR>", "Branches" },
    commit_history = { "<cmd>Telescope git_commits<CR>", "Commit History" },
    lsp_references = { "<cmd>Telescope lsp_references<CR>", "References" },
    undo = { "<cmd>Telescope undo<CR>", "Undo" }
}
