local Utils = require("user.utils")

local function get_cmp_config(cmp, luasnip, config)
    local keymaps = require("config.keymaps").cmp
    local icons = require("config.icons")
    return {
        enabled = function() -- Disable cmp if writing a comment or using a Prompt
            if vim.bo.filetype == "prompt" then
                return false
            end

            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                local context = require("cmp.config.context")
                return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
            end
        end,
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            [keymaps.select_prev_item] = cmp.mapping.select_prev_item(),
            [keymaps.select_next_item] = cmp.mapping.select_next_item(),
            [keymaps.scroll_up] = cmp.mapping.scroll_docs(-4),
            [keymaps.scroll_down] = cmp.mapping.scroll_docs(4),
            [keymaps.insert_mode_complete] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            [keymaps.abort_and_close] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- Accept currently selected item. If none selected, `select` first item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            [keymaps.confirm] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    local confirm_opts = {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }

                    -- Prevent overwriting brackets if on insert mode
                    if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
                        confirm_opts.behavior = cmp.ConfirmBehavior.Insert
                    end

                    local entry = cmp.get_selected_entry()
                    local is_copilot = entry and entry.source.name == "copilot"
                    if is_copilot then
                        confirm_opts.behavior = cmp.ConfirmBehavior.Replace
                        confirm_opts.select = true
                    end

                    if cmp.confirm(confirm_opts) then
                        return -- success, exit early
                    end
                end
                fallback() -- if not exited early, always fallback
            end),
            [keymaps.super_autocomplete] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif config.jumpable(1) then
                    luasnip.jump(1)
                elseif config.has_words_before() then
                    fallback()
                else
                    fallback()
                end
            end, { "i", "s" }),
            [keymaps.prev_super_autocomplete] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local icon_kind = vim_item.kind

                if entry.source.name == "copilot" then
                    icon_kind = "Copilot"
                    vim_item.kind_hl_group = "CmpItemKindCopilot"
                end

                vim_item.kind = icons.kinds[icon_kind]
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    path = "[Path]",
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    copilot = "[Copilot]",
                    treesitter = "[Tree-sitter]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = {
            {
                name = "copilot",
                max_item_count = 3,
                trigger_characters = {
                    { ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", "/", "\\", "+", "?", " " },
                },
            },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "treesitter" },
        },
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        experimental = {
            ghost_text = true,
            native_menu = false,
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                -- compare.scopes,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                -- compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    }
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        {
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
    },
    event = {
        "InsertEnter",
        "CmdlineEnter",
    },
    config = function()
        Utils.callback_if_ok_msg_mult({ "cmp", "luasnip" }, function(required)
            local cmp = required["cmp"]
            local luasnip = required["luasnip"]

            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp_config = {
                has_words_before = function()
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0
                        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end,
                ---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
                ---@param dir number 1 for forward, -1 for backward; defaults to 1
                ---@return boolean true if a jumpable luasnip field is found while inside a snippet
                jumpable = function(dir)
                    local win_get_cursor = vim.api.nvim_win_get_cursor
                    local get_current_buf = vim.api.nvim_get_current_buf

                    ---sets the current buffer's luasnip to the one nearest the cursor
                    ---@return boolean true if a node is found, false otherwise
                    local function seek_luasnip_cursor_node()
                        -- TODO(kylo252): upstream this
                        -- for outdated versions of luasnip
                        if not luasnip.session.current_nodes then
                            return false
                        end

                        local node = luasnip.session.current_nodes[get_current_buf()]
                        if not node then
                            return false
                        end

                        local snippet = node.parent.snippet
                        local exit_node = snippet.insert_nodes[0]

                        local pos = win_get_cursor(0)
                        pos[1] = pos[1] - 1

                        -- exit early if we're past the exit node
                        if exit_node then
                            local exit_pos_end = exit_node.mark:pos_end()
                            if
                                (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2])
                            then
                                snippet:remove_from_jumplist()
                                luasnip.session.current_nodes[get_current_buf()] = nil

                                return false
                            end
                        end

                        node = snippet.inner_first:jump_into(1, true)
                        while node ~= nil and node.next ~= nil and node ~= snippet do
                            local n_next = node.next
                            local next_pos = n_next and n_next.mark:pos_begin()
                            local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
                                or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

                            -- Past unmarked exit node, exit early
                            if n_next == nil or n_next == snippet.next then
                                snippet:remove_from_jumplist()
                                luasnip.session.current_nodes[get_current_buf()] = nil

                                return false
                            end

                            if candidate then
                                luasnip.session.current_nodes[get_current_buf()] = node
                                return true
                            end

                            local ok
                            ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
                            if not ok then
                                snippet:remove_from_jumplist()
                                luasnip.session.current_nodes[get_current_buf()] = nil

                                return false
                            end
                        end

                        -- No candidate, but have an exit node
                        if exit_node then
                            -- to jump to the exit node, seek to snippet
                            luasnip.session.current_nodes[get_current_buf()] = snippet
                            return true
                        end

                        -- No exit node, exit from snippet
                        snippet:remove_from_jumplist()
                        luasnip.session.current_nodes[get_current_buf()] = nil
                        return false
                    end

                    if dir == -1 then
                        return luasnip.in_snippet() and luasnip.jumpable(-1)
                    else
                        return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
                    end
                end,
            }

            luasnip.filetype_extend("astro", { "html" })

            local config = get_cmp_config(cmp, luasnip, cmp_config)
            cmp.setup(config)
        end)
    end,
}
