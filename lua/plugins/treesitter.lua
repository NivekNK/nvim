local autopairs_config = {
    check_ts = true, -- treesitter integration
    disable_filetype = { "TelescopePrompt" },
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false
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
        highlight_grey = "LineNr"
    }
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
        additional_vim_regex_highlighting = false
    },

    context_commentstring = {
        enable = true,
        enable_autocmd = false
    },

    autopairs = {
        enable = true
    }
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
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                event = "VeryLazy"
            },
            {
                "nvim-tree/nvim-web-devicons",
                event = "VeryLazy"
            }
        },
        config = function()
            local treesitter_ok, _ = pcall(require, "nvim-treesitter")
            if not treesitter_ok then
                vim.notify("Error loading treesitter!", vim.log.levels.ERROR)
                return
            end

            local treesitter_install = require("nvim-treesitter.install")
            treesitter_install.compilers = { "clang" }
            treesitter_install.prefer_git = false

            local languages = {}
            for lang, _ in pairs(require("config.servers")) do
                table.insert(languages, lang)
            end

            local treesitter_config = get_treesitter_config(languages)
            require("nvim-treesitter.configs").setup(treesitter_config)
        end
    }
}
