return {
    find_files = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>",
        "Find Files"
    },
    live_grep = { "<cmd>Telescope live_grep theme=ivy<CR>", "Find Text" },
    buffers = { "<cmd>Telescope buffers<CR>", "Find Buffers" }
}
