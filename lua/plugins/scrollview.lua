local Utils = require("user.utils")

local scrollview_config = {
    always_show = false,
    base = "right",
    byte_limit = 1000000,
    character = "",
    column = 1,
    current_only = true,
    excluded_filetypes = {
        "nerdtree",
        "neo-tree",
        "NvimTree",
        "TelescopePrompt",
        "prompt",
        "cmp_menu",
        "cmp_docs",
    },
    floating_windows = false,
    hide_on_intersect = false,
    hover = true,
    include_end_region = false,
    line_limit = 100000,
    mode = "auto",
    mouse_primary = "left",
    mouse_secondary = "right",
    on_startup = true,
    winblend = 70,
    winblend_gui = 70,
    zindex = 40,
    signs_max_per_row = 3,
    signs_on_startup = {
        "diagnostics",
        "search",
        "conflicts",
        "spell",
        "marks",
        "nk_cursor",
    },
    signs_overflow = "left",
    signs_show_in_folds = true,
    changelist_previous_priority = 0,
    changelist_previous_symbol = "",
    changelist_current_priority = 0,
    changelist_current_symbol = "",
    changelist_next_priority = 0,
    changelist_next_symbol = "",
    conflicts_bottom_priority = 80,
    conflicts_bottom_symbol = "",
    conflicts_middle_priority = 75,
    conflicts_middle_symbol = "",
    conflicts_top_priority = 70,
    conflicts_top_symbol = "",
    cursor_priority = 0,
    cursor_symbol = "",
    diagnostics_error_priority = 60,
    diagnostics_error_symbol = { "", "", "" },
    diagnostics_hint_priority = 30,
    diagnostics_hint_symbol = { "", "", "" },
    diagnostics_info_priority = 40,
    diagnostics_info_symbol = { "", "", "" },
    diagnostics_warn_priority = 50,
    diagnostics_warn_symbol = { "", "", "" },
    folds_priority = 30,
    folds_symbol = { "", "", "" },
    latestchange_priority = 0,
    latestchange_symbol = "",
    loclist_priority = 0,
    loclist_symbol = "",
    --marks_characters = {}, -- a-z and A-Z
    marks_priority = 50,
    quickfix_priority = 0,
    quickfix_symbol = "",
    search_priority = 70,
    search_symbol = { "", "", "" },
    spell_priority = 20,
    spell_symbol = { "", "", "" },
    textwidth_priority = 0,
    textwidth_symbol = "",
    trail_priority = 0,
    trail_symbol = "",
    diagnostics_severities = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.HINT,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.WARN,
    }
}

return {
    "dstein64/nvim-scrollview",
    event = "BufEnter",
    config = function()
        Utils.callback_if_ok_msg("scrollview", function(scrollview)
            local group = "nk_cursor"
            local registration = scrollview.register_sign_spec({
                current_only = true,
                group = group,
                highlight = "Normal",
                priority = 100,
                show_in_folds = true,
                symbol = "",
            })
            local name = registration.name
            scrollview.set_sign_group_state(group, true)

            vim.api.nvim_create_autocmd("User", {
                pattern = "ScrollViewRefresh",
                callback = function()
                    if not scrollview.is_sign_group_active(group) then return end
                    for _, winid in ipairs(scrollview.get_sign_eligible_windows()) do
                        local bufnr = vim.api.nvim_win_get_buf(winid)
                        vim.b[bufnr][name] = { vim.fn.line(".") }
                    end
                end
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                callback = function()
                    if not scrollview.is_sign_group_active(group) then return end
                    local lines = vim.b[name]
                    if lines == nil or lines[1] ~= vim.fn.line(".") then
                        vim.cmd("silent! ScrollViewRefresh")
                    end
                end
            })

            scrollview.setup(scrollview_config)
        end)
    end,
}
