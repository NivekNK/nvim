local Utils = require("user.utils")

local function get_cokeline_config(utils)
    local is_picking_focus = require("cokeline/mappings").is_picking_focus
    local is_picking_close = require("cokeline/mappings").is_picking_close
    local icons = require("config.icons")
    return {
        -- Only show the bufferline when there are at least this many visible buffers.
        -- default: `1`.
        show_if_buffers_are_at_least = 1,
        buffers = {
            -- A function to filter out unwanted buffers. Takes a buffer table as a
            -- parameter (see the following section for more infos) and has to return
            -- either `true` or `false`.
            -- default: `false`.
            filter_valid = false,
            -- A looser version of `filter_valid`, use this function if you still
            -- want the `cokeline-{switch,focus}-{prev,next}` mappings to work for
            -- these buffers without displaying them in your bufferline.
            -- default: `false`.
            filter_visible = false,
            -- Which buffer to focus when a buffer is deleted, `prev` focuses the
            -- buffer to the left of the deleted one while `next` focuses the one the
            -- right.
            -- default: 'next'.
            focus_on_delete = "next",
            -- If set to `last` new buffers are added to the end of the bufferline,
            -- if `next` they are added next to the current buffer.
            -- if set to `directory` buffers are sorted by their full path.
            -- if set to `number` buffers are sorted by bufnr, as in default Neovim
            -- default: 'last'.
            new_buffers_position = "last",
            -- If true, right clicking a buffer will close it
            -- The close button will still work normally
            -- Default: true
            delete_on_right_click = true,
        },
        mappings = {
            -- Controls what happens when the first (last) buffer is focused and you
            -- try to focus/switch the previous (next) buffer. If `true` the last
            -- (first) buffers gets focused/switched, if `false` nothing happens.
            -- default: `true`.
            cycle_prev_next = true,
        },
        rendering = {
            -- The maximum number of characters a rendered buffer is allowed to take
            -- up. The buffer will be truncated if its width is bigger than this
            -- value.
            -- default: `999`.
            max_buffer_width = 999,
        },
        pick = {
            -- Whether to use the filename's first letter first before
            -- picking a letter from the valid letters list in order.
            -- default: `true`
            use_filename = true,
            -- The list of letters that are valid as pick letters. Sorted by
            -- keyboard reachability by default, but may require tweaking for
            -- non-QWERTY keyboard layouts.
            -- default: `'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERTYQP'`
            letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERTYQP",
        },
        -- The default highlight group values.
        -- The `fg` and `bg` keys are either colors in hexadecimal format or
        -- functions taking a `buffer` parameter and returning a color in
        -- hexadecimal format. Similarly, the `style` key is either a string
        -- containing a comma separated list of items in `:h attr-list` or a
        -- function returning one.
        default_hl = {
            -- default: `ColorColumn`'s background color for focused buffers,
            -- `Normal`'s foreground color for unfocused ones.
            fg = "Normal",
            -- default: `Normal`'s foreground color for focused buffers,
            -- `ColorColumn`'s background color for unfocused ones.
            -- default: `Normal`'s foreground color.
            bg = "Normal",
            -- default: `'NONE'`.
            style = "NONE",
        },
        -- A list of components to be rendered for each buffer. Check out the section
        -- below explaining what this value can be set to.
        -- default: see `/lua/cokeline/defaults.lua`
        -- Dark Background: TabLine
        -- Hightlight: Normal
        components = {
            {
                text = function(buffer)
                    return buffer.index ~= 1 and "" or " "
                end,
                fg = utils.get_hex("CursorLine", "bg"),
                bg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
            },
            {
                text = function(buffer)
                    return (is_picking_focus() or is_picking_close()) and " " .. buffer.pick_letter .. " " or
                    " " .. buffer.devicon.icon
                end,
                fg = function(_)
                    if is_picking_focus() then
                        return utils.get_hex("WarningMsg", "fg")
                    elseif is_picking_close() then
                        return utils.get_hex("ErrorMsg", "fg")
                    else
                        return utils.get_hex("NeoTreeNormal", "fg")
                    end
                end,
                bg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
                style = function(_)
                    return (is_picking_focus() or is_picking_close()) and "italic,bold" or nil
                end,
            },
            {
                text = function(buffer)
                    return buffer.unique_prefix .. buffer.filename
                end,
                fg = utils.get_hex("NeoTreeNormal", "fg"),
                bg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
                style = function(buffer)
                    return buffer.is_focused and "bold" or nil
                end,
            },
            {
                text = function(buffer)
                    return buffer.is_modified and "*" or " "
                end,
                fg = utils.get_hex("NeoTreeNormal", "fg"),
                bg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
            },
            {
                text = function(buffer)
                    return (buffer.diagnostics.errors ~= 0 and " " .. icons.error .. " ")
                        or (buffer.diagnostics.warnings ~= 0 and " " .. icons.warning .. " ")
                        or (buffer.diagnostics.infos ~= 0 and " " .. icons.info .. " ")
                        or (buffer.diagnostics.hints ~= 0 and " " .. icons.hint .. " ")
                        or "   "
                end,
                fg = function(buffer)
                    return (buffer.diagnostics.errors ~= 0 and utils.get_hex("DiagnosticError", "fg"))
                        or (buffer.diagnostics.warnings ~= 0 and utils.get_hex("DiagnosticWarn", "fg"))
                        or (buffer.diagnostics.infos ~= 0 and utils.get_hex("DiagnositicInfo", "fg"))
                        or (buffer.diagnostics.hints ~= 0 and utils.get_hex("DiagnosticHint", "fg"))
                        or nil
                end,
                bg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
            },
            {
                text = "",
                fg = function(buffer)
                    return buffer.is_focused and utils.get_hex("CursorLine", "bg") or utils.get_hex("TabLine", "bg")
                end,
                bg = utils.get_hex("CursorLine", "bg"),
            },
            {
                text = function(buffer)
                    return buffer.is_last and "" or ""
                end,
                fg = utils.get_hex("CursorLine", "bg"),
                bg = utils.get_hex("TabLine", "bg"),
            }
        },
        -- Left sidebar to integrate nicely with file explorer plugins.
        -- This is a table containing a `filetype` key and a list of `components` to
        -- be rendered in the sidebar.
        -- The last component will be automatically space padded if necessary
        -- to ensure the sidebar and the window below it have the same width.
        sidebar = {
            filetype = "neo-tree",
            components = {
                {
                    text = " EXPLORER",
                    fg = utils.get_hex("Comment", "fg"),
                    bg = utils.get_hex("TabLine", "bg"),
                    style = "italic",
                },
            },
        }
    }
end

return {
    "willothy/nvim-cokeline",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
    },
    config = function()
        Utils.callback_if_ok_msg("cokeline", function(cokeline)
            local cokeline_config = get_cokeline_config(require("cokeline.utils"))
            cokeline.setup(cokeline_config)
        end)
    end,
}
