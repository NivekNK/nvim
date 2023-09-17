return {
	toggle_marks = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Marks" },
	add_mark = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add Mark" },
	marks_next = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "Next Mark" },
	marks_prev = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "Prev Mark" },
}
