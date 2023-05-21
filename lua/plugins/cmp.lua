local function get_cmp_config(cmp, luasnip, check_backspace)
local keymaps = require("config.keymaps").cmp
local icons = require("config.icons")
return {
    enabled = function() -- Disable cmp if writing a comment or using a Prompt
        if vim.bo.buftype == 'prompt' then
            return false
        end

        if vim.api.nvim_get_mode().mode == "c" then
            return true
        else
            local context = require("cmp.config.context")
            return not context.in_treesitter_capture("comment") and
                   not context.in_syntax_group("Comment")
        end
    end,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        [keymaps.select_prev_item] = cmp.mapping.select_prev_item(),
        [keymaps.select_next_item] = cmp.mapping.select_next_item(),
        [keymaps.scroll_down] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        [keymaps.scroll_up] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        [keymaps.insert_mode_complete] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        [keymaps.abort_and_close] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        [keymaps.confirm] = cmp.mapping.confirm { select = true },
        [keymaps.super_autocomplete] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
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
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local icon_kind = vim_item.kind
            vim_item.kind = icons.kinds[icon_kind]
            vim_item.menu = ({
                nvim_lsp = "",
                nvim_lua = "",
                luasnip = "",
                buffer = "",
                path = "",
                emoji = "",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
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
            }
        },
        "hrsh7th/cmp-nvim-lua",
    },
    event = {
        "InsertEnter",
        "CmdlineEnter",
    },
    config = function()
        local cmp_ok, cmp = pcall(require, "cmp")
        if not cmp_ok then
            vim.notify("Error loading cmp!", vim.log.levels.ERROR)
            return
        end

        local luasnip_ok, luasnip = pcall(require, "luasnip")
        if not luasnip_ok then
            vim.notify("[cmp] Error loading luasnip!", vim.log.levels.ERROR)
            return
        end
        require("luasnip.loaders.from_vscode").lazy_load()

        local check_backspace = function()
            local col = vim.fn.col "." - 1
            return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
        end

        local config = get_cmp_config(cmp, luasnip, check_backspace)
        cmp.setup(config)
    end,
}
