local Utils = require("user.utils")
local keymaps = require("config.keymaps").nvim_tree
local nvim_tree_api = require("nvim-tree.api")

local M = {}

M.autocmd_nvim_tree_startup = function(data)
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    if no_name then
        nvim_tree_api.tree.toggle({ focus = false, find_file = true })
        return
    end

    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
        vim.cmd.cd(data.file)
        nvim_tree_api.tree.open()
    end
end

M.autocmd_nvim_tree_deleted_buffer = function()
    local length = #vim.api.nvim_list_wins()
    if length == 1 and nvim_tree_api.tree.is_tree_buf() then
        vim.defer_fn(function()
            nvim_tree_api.tree.toggle({ find_file = true, focus = true })
            nvim_tree_api.tree.toggle({ find_file = true, focus = true })
            vim.cmd("wincmd p")
        end, 0)
    end
end

M.on_attach_nvim_tree_keymaps = function(bufnr)
    local mark_and_trash = function()
        local marks = nvim_tree_api.marks.list()
        if #marks == 0 then
            table.insert(marks, nvim_tree_api.tree.get_node_under_cursor())
        end

        for _, node in ipairs(marks) do
            nvim_tree_api.fs.trash(node)
        end

        nvim_tree_api.marks.clear()
        nvim_tree_api.tree.reload()
    end

    local mark_and_remove = function()
        local marks = nvim_tree_api.marks.list()
        if #marks == 0 then
            table.insert(marks, nvim_tree_api.tree.get_node_under_cursor())
        end

        local message
        if #marks == 1 then
            message = string.format("Delete '%s'? [y/n]: ", marks[1].name)
        else
            message = string.format("Delete %s files? [y/n]: ", #marks)
        end

        vim.ui.input({ prompt = message },
            function(input)
                if input == "y" then
                    for _, node in ipairs(marks) do
                        nvim_tree_api.fs.remove(node)
                    end

                    nvim_tree_api.marks.clear()
                    nvim_tree_api.tree.reload()
                end
            end
        )
    end

    local mark_and_copy = function()
        local marks = nvim_tree_api.marks.list()
        if #marks == 0 then
            table.insert(marks, nvim_tree_api.tree.get_node_under_cursor())
        end

        for _, node in ipairs(marks) do
            nvim_tree_api.fs.copy.node(node)
        end

        nvim_tree_api.marks.clear()
        nvim_tree_api.tree.reload()
    end

    local mark_and_cut = function()
        local marks = nvim_tree_api.marks.list()
        if #marks == 0 then
            table.insert(marks, nvim_tree_api.tree.get_node_under_cursor())
        end

        for _, node in ipairs(marks) do
            nvim_tree_api.fs.cut(node)
        end

        nvim_tree_api.marks.clear()
        nvim_tree_api.tree.reload()
    end

    local mark_and_move = function()
        if #nvim_tree_api.marks.list() == 0 then
            nvim_tree_api.marks.toggle(nvim_tree_api.tree.get_node_under_cursor())
        end

        nvim_tree_api.marks.bulk.move()

        nvim_tree_api.marks.clear()
        nvim_tree_api.tree.reload()
    end

    local nvim_tree_keymaps = {
        [keymaps.trash_file] = { mark_and_trash, "Trash File(s)" },
        [keymaps.delete_file] = { mark_and_remove, "Delete File(s)" },
        [keymaps.copy_file] = { mark_and_copy, "Copy File(s)" },
        [keymaps.cut_file] = { mark_and_cut, "Cut File(s)" },
        [keymaps.paste] = { nvim_tree_api.fs.paste, "Paste" },
        [keymaps.select_file] = { nvim_tree_api.marks.toggle, "Select File" },
        [keymaps.move_file] = { mark_and_move, "Move File(s)" },
        [keymaps.open] = { nvim_tree_api.node.open.edit, "Open" },
        [keymaps.rename] = { nvim_tree_api.fs.rename, "Rename" },
        [keymaps.rename_omit_filename] = { nvim_tree_api.fs.rename_sub, "Rename: Omit filename" },
        [keymaps.new_file] = { nvim_tree_api.fs.create, "New File" },
        [keymaps.copy_absolute_path] = { nvim_tree_api.fs.copy.absolute_path, "Copy Absolute Path" },
        [keymaps.copy_relative_path] = { nvim_tree_api.fs.copy.relative_path, "Copy Relative Path" },
        [keymaps.copy_filename] = { nvim_tree_api.fs.copy.filename, "Copy Filename" },
        [keymaps.change_working_directory] = { nvim_tree_api.tree.change_root_to_node, "Change Working Directory" },
        [keymaps.open_horizontal_split] = { nvim_tree_api.node.open.horizontal, "Open: Horizontal Split" },
        [keymaps.open_vertical_split] = { nvim_tree_api.node.open.vertical, "Open: Vertical Split" },
    }

    local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    for keymap, values in pairs(nvim_tree_keymaps) do
        vim.keymap.set("n", keymap, values[1], opts(values[2]))
    end
end

M.nvim_tree_toggle = function()
    local buffer = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buffer })
    if filetype == "NvimTree" then
        nvim_tree_api.tree.toggle()
    else
        nvim_tree_api.tree.focus()
    end
end

M.find_directory_and_focus = function()
    if not Utils.require_check("telescope") then
        return
    end

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                nvim_tree_api.tree.open()
                nvim_tree_api.tree.find_file(selection.cwd .. "/" .. selection.value)
            end)
            return true
        end
    })
end

return M
