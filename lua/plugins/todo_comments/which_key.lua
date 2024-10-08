local pickers = require("telescope.builtin")
local Config = require("todo-comments.config")
local Highlight = require("todo-comments.highlight")
local make_entry = require("telescope.make_entry")

local function keywords_filter(opts_keywords)
    assert(not opts_keywords or type(opts_keywords) == "string", "'keywords' must be a comma separated string or nil")
    local all_keywords = vim.tbl_keys(Config.keywords)
    if not opts_keywords then
        return all_keywords
    end
    local filters = vim.split(opts_keywords, ",")
    return vim.tbl_filter(function(kw)
        return vim.tbl_contains(filters, kw)
    end, all_keywords)
end

local function comments(config)
    if not config then
        vim.notify("[plugins.todo-comments.which-key] Error >> opts for which-key command not set!",
            vim.log.levels.ERROR)
    end

    local opts = config and config.theme or {}

    opts.vimgrep_arguments = { Config.options.search.command }
    vim.list_extend(opts.vimgrep_arguments, Config.options.search.args)

    opts.search = Config.search_regex(keywords_filter(config.opts.keywords))
    opts.prompt_title = config.opts.keywords
    opts.use_regex = true
    local entry_maker = make_entry.gen_from_vimgrep(opts)
    opts.entry_maker = function(line)
        local ret = entry_maker(line)
        ret.display = function(entry)
            local display = config.opts.display and string.format("%s:%s:%s ", entry.filename, entry.lnum, entry.col) or
                ""
            local text = entry.text
            local start, finish, kw = Highlight.match(text)

            local hl = {}

            if start then
                kw = Config.keywords[kw] or kw
                local icon = Config.options.keywords[kw].icon
                display = icon .. " " .. display
                table.insert(hl, { { 1, #icon + 1 }, "TodoFg" .. kw })
                text = vim.trim(text:sub(start))

                table.insert(hl, {
                    { #display, #display + finish - start + 2 },
                    "TodoBg" .. kw,
                })
                table.insert(hl, {
                    { #display + finish - start + 1, #display + finish + 1 + #text },
                    "TodoFg" .. kw,
                })
                display = display .. " " .. text
            end

            return display, hl
        end
        return ret
    end
    pickers.grep_string(opts)
end

local Utils = require("user.utils")

local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>c",
            group = "Comments",
            buffer = true,
        },
        {
            "<leader>cc",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                        search_dirs = { vim.api.nvim_buf_get_name(0) },
                    }),
                    opts = {
                        display = false,
                    },
                })
            end,
            desc = "Comments",
            buffer = true,
            cond = function()
                return Utils.check_filetype("modifiable-file")
            end,
        },
        {
            "<leader>ca",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                    },
                })
            end,
            desc = "All Comments",
            buffer = true,
        },
        {
            "<leader>cf",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "FIX",
                    },
                })
            end,
            desc = "FIX",
            buffer = true,
        },
        {
            "<leader>ct",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "TODO",
                    },
                })
            end,
            desc = "TODO",
            buffer = true,
        },
        {
            "<leader>ch",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "HACK",
                    },
                })
            end,
            desc = "HACK",
            buffer = true,
        },
        {
            "<leader>cw",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "WARN",
                    },
                })
            end,
            desc = "WARN",
            buffer = true,
        },
        {
            "<leader>cp",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "PERF",
                    },
                })
            end,
            desc = "PERF",
            buffer = true,
        },
        {
            "<leader>cn",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "NOTE",
                    },
                })
            end,
            desc = "NOTE",
            buffer = true,
        },
        {
            "<leader>ce",
            function()
                comments({
                    theme = require("telescope.themes").get_ivy({
                        previewer = false,
                        layout_config = {
                            height = 20,
                        },
                        initial_mode = "normal",
                    }),
                    opts = {
                        display = true,
                        keywords = "TEST",
                    },
                })
            end,
            desc = "TEST",
            buffer = true,
        },
    })
end

return M
