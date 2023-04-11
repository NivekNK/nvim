local icons = require("config.icons")
local keymaps = require("config.keymaps")

local config = {
    mason_lspconfig = {
        -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
        -- This setting has no relation with the `automatic_installation` setting.
        ensure_installed = {},

        -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
        -- This setting has no relation with the `ensure_installed` setting.
        -- Can either be:
        --   - false: Servers are not automatically installed.
        --   - true: All servers set up via lspconfig are automatically installed.
        --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
        --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
        automatic_installation = true
    },
    mason = {
        -- The directory in which to install packages.
        install_root_dir = vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "mason",

        -- Where Mason should put its bin location in your PATH. Can be one of:
        -- - "prepend" (default, Mason's bin location is put first in PATH)
        -- - "append" (Mason's bin location is put at the end of PATH)
        -- - "skip" (doesn't modify PATH)
        ---@type '"prepend"' | '"append"' | '"skip"'
        PATH = "prepend",

        -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
        -- debugging issues with package installations.
        log_level = vim.log.levels.INFO,

        -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
        -- packages that are requested to be installed will be put in a queue.
        max_concurrent_installers = 4,

        -- [Advanced setting]
        -- The registries to source packages from. Accepts multiple entries. Should a package with the same name exist in
        -- multiple registries, the registry listed first will be used.
        registries = {
            "lua:mason-registry.index"
        },

        -- The provider implementations to use for resolving supplementary package metadata (e.g., all available versions).
        -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
        -- Builtin providers are:
        --   - mason.providers.registry-api  - uses the https://api.mason-registry.dev API
        --   - mason.providers.client        - uses only client-side tooling to resolve metadata
        providers = {
            "mason.providers.registry-api",
            "mason.providers.client"
        },

        github = {
            -- The template URL to use when downloading assets from GitHub.
            -- The placeholders are the following (in order):
            -- 0. The repository (e.g. "rust-lang/rust-analyzer")
            -- 1. The release version (e.g. "v0.3.0")
            -- 2. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
            download_url_template = "https://github.com/%s/releases/download/%s/%s"
        },

        pip = {
            -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
            upgrade_pip = false,

            -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
            -- and is not recommended.
            --
            -- Example: { "--proxy", "https://proxyserver" }
            install_args = {}
        },

        ui = {
            -- Whether to automatically check for new versions when opening the :Mason window.
            check_outdated_packages_on_open = true,

            -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
            border = "rounded",

            -- Width of the window. Accepts:
            -- - Integer greater than 1 for fixed width.
            -- - Float in the range of 0-1 for a percentage of screen width.
            width = 0.8,

            -- Height of the window. Accepts:
            -- - Integer greater than 1 for fixed height.
            -- - Float in the range of 0-1 for a percentage of screen height.
            height = 0.9,

            icons = {
                -- The list icon to use for installed packages.
                package_installed = icons.git_staged,
                -- The list icon to use for packages that are installing, or queued for installation.
                package_pending = icons.git_unstaged,
                -- The list icon to use for packages that are not installed.
                package_uninstalled = icons.item_deleted
            },

            keymaps = keymaps.mason
        }
    }
}

local function on_attach(client, buffer)
    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if null_ls_ok then
        local sources = require("null-ls.sources")
        local available_sources = sources.get_available(vim.bo.filetype, null_ls.methods.FORMATTING)
        if #available_sources > 0 then
            client.server_capabilities.document_formatting = false
        end
    else
        vim.notify("[mason] Error loading null-ls!", vim.log.levels.ERROR)
    end
end

local function get_capabilities()
    return nil
end

return {
    {
        "williamboman/mason.nvim",
        config = function()
            local mason_ok, mason = pcall(require, "mason")
            if not mason_ok then
                vim.notify("Error loading mason!", vim.log.levels.ERROR)
                return
            end

            mason.setup(config.mason)
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not mason_lspconfig_ok then
                vim.notify("Error loading mason-lspconfig!", vim.log.levels.ERROR)
                return
            end

            mason_lspconfig.setup(config.mason_lspconfig)

--            for _, server in pairs(config.mason_lspconfig.ensure_installed) do
--                local opts = {
--                    on_attach = on_attach,
--                    capabilities = get_capabilities()
--                }
--
--                local has_custom, custom = pcall(require, "user.lsp.settings." .. server)
--                if has_custom then
--                    opts = vim.tbl_deep_extend("force", opts, custom.opts)
--                end
--
--                if custom.server then
--                    custom.server(opts)
--                else
--                    lspconfig[server].setup(opts)
--                end
--            end
        end
    }
}
