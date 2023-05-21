local autopairs_config = {
    check_ts = true, -- treesitter integration
    disable_filetype = { "TelescopePrompt" },
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
    },
    fast_wrap = {
        map = require("config.keymaps").treesitter.autopairs_fast_wrap,
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
    },
}

local indent_blankline_config = {
    char = "▏",
    space_char_blankline = " ",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
        "help",
        "packer",
        "neo-tree",
    },
}

local treesj_config = {
    -- Use default keymaps
    -- (<space>m - toggle, <space>j - join, <space>s - split)
    use_default_keymaps = false,

    -- Node with syntax error will not be formatted
    check_syntax_error = true,

    -- If line after join will be longer than max value,
    -- node will not be formatted
    max_join_length = 1000,

    -- hold|start|end:
    -- hold - cursor follows the node/place on which it was called
    -- start - cursor jumps to the first symbol of the node being formatted
    -- end - cursor jumps to the last symbol of the node being formatted
    cursor_behavior = "hold",

    -- Notify about possible problems or not
    notify = true,
    langs = {},

    -- Use `dot` for repeat action
    dot_repeat = true,
}

local function get_treesitter_config(languages)
return {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = languages,

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {},
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --    local max_filesize = 100 * 1024 -- 100 KB
        --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --    if ok and stats and stats.size > max_filesize then
        --        return true
        --    end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },

    autopairs = {
        enable = true,
    },

    indent = {
        enable = true,
    },
}
end

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        cond = function()
            local cmp_ok, _ = pcall(require, "cmp")
            return cmp_ok
        end,
        config = function()
            local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
            if not autopairs_ok then
                vim.notify("[treesitter] Error loading autopairs!", vim.log.levels.ERROR)
                return
            end
            autopairs.setup(autopairs_config)

            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local indent_blankline_ok, indent_blankline = pcall(require, "indent_blankline")
            if not indent_blankline_ok then
                vim.notify("[treesitter] Error loading indent-blankline!", vim.log.levels.ERROR)
                return
            end
            indent_blankline.setup(indent_blankline_config)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                event = "VeryLazy",
            },
            {
                "nvim-tree/nvim-web-devicons",
                event = "VeryLazy",
            },
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "Wansmer/treesj",
                config = function()
                    local treesj_ok, treesj = pcall(require, "treesj")
                    if not treesj_ok then
                        vim.notify("[treesitter] Error loading treesj!", vim.log.levels.ERROR)
                        return
                    end
                    treesj.setup(treesj_config)
                end,
            },
        },
        config = function()
            local treesitter_ok, _ = pcall(require, "nvim-treesitter")
            if not treesitter_ok then
                vim.notify("Error loading treesitter!", vim.log.levels.ERROR)
                return
            end

            require("nvim-treesitter.install").compilers = { "clang" }
            require("nvim-treesitter.install").prefer_git = false

            local languages = {}
            for lang, _ in pairs(require("config.servers")) do
                table.insert(languages, lang)
            end

            local treesitter_config = get_treesitter_config(languages)
            require("nvim-treesitter.configs").setup(treesitter_config)
        end,
    }
}
