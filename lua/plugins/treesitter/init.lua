local Utils = require("user.utils")

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

local autotag_config = {
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
    }
}

local ibl_config = {
    enabled = true,
    debounce = 200,
    viewport_buffer = {
        min = 30,
        max = 500,
    },
    indent = {
        char = "▏",
        tab_char = nil,
        highlight = "IblIndent",
        smart_indent_cap = true,
        priority = 1,
        repeat_linebreak = true,
    },
    whitespace = {
        highlight = "IblWhitespace",
        remove_blankline_trail = true,
    },
    scope = {
        enabled = true,
        char = nil,
        show_start = false,
        show_end = true,
        show_exact_scope = false,
        injected_languages = true,
        highlight = "IblScope",
        priority = 1024,
        include = {
            node_type = {},
        },
        exclude = {
            language = {},
            node_type = {
                ["*"] = {
                    "source_file",
                    "program",
                },
                lua = {
                    "chunk",
                },
                python = {
                    "module",
                },
            },
        },
    },
    exclude = {
        filetypes = {
            "lspinfo",
            "packer",
            "lazy",
            "checkhealth",
            "help",
            "man",
            "gitcommit",
            "TelescopePrompt",
            "TelescopeResults",
            "neo-tree",
        },
        buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
        },
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

local function get_treesitter_config()
    return {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = require("user.utils.servers").lang(),
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,
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
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            Utils.callback_if_ok_msg("nvim-autopairs", function(autopairs)
                autopairs.setup(autopairs_config)
                Utils.callback_if_ok("cmp", function(cmp)
                    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end)
            end)
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            Utils.callback_if_ok_msg("ibl", function(ibl)
                ibl.setup(ibl_config)
            end)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
                    Utils.callback_if_ok_msg("treesj", function(treesj)
                        treesj.setup(treesj_config)
                    end)
                end,
            },
            {
                "danymat/neogen",
                config = true,
                version = "*",
            },
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
                config = function()
                    Utils.callback_if_ok_msg("nvim-ts-autotag", function(autotag)
                        autotag.setup(autotag_config)
                    end)
                end,
            },
            "b0o/schemastore.nvim",
        },
        config = function()
            if not Utils.require_check("nvim-treesitter") then
                Utils.notify_error("Error >> treesitter not found!")
                return
            end

            require("nvim-treesitter.install").compilers = { "clang" }
            if Utils.is_windows() then
                require("nvim-treesitter.install").command_extra_args = { clang = { "--target=x86_64-pc-windows-gnu" } }
            end
            require("nvim-treesitter.install").prefer_git = false

            require("nvim-treesitter.configs").setup(get_treesitter_config())

            vim.g.skip_ts_context_commentstring_module = true
            ---@diagnostic disable-next-line: missing-fields
            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })

            vim.cmd("TSUpdateSync")
        end,
    },
}
