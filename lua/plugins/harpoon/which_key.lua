return {
    add_mark = { "<cmd>lua require('harpoon'):list():append()<CR>", "Add Mark" },
    marks_next = { "<cmd>lua require('harpoon'):list():next()<CR>", "Next Mark" },
    marks_prev = { "<cmd>lua require('harpoon'):list():prev()<CR>", "Prev Mark" },
    toggle_marks = {
        function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, "Marks"
    },
    marks = { "<cmd>NKHarpoonMarksTelescope<CR>", "Marks" }
}
