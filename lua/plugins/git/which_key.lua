return {
    next_hunk = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    prev_hunk = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    blame = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    preview_hunk = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    reset_hunk = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    reset_buffer = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    stage_hunk = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    undo_stage_hunk = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    diff = { "<cmd>Gitsigns diffthis HEAD<CR>", "Diff" },
}
