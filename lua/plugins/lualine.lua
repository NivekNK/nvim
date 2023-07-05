local icons = require("config.icons")
local lualine_config = {
    options = {
        icons_enabled = true,
        theme = "auto", -- lualine theme
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {       -- Filetypes to disable lualine for.
            statusline = {},         -- only ignores the ft for statusline.
            winbar = {},             -- only ignores the ft for winbar.
        },

        ignore_focus = {},           -- If current filetype is in this list it'll
                                     -- always be drawn as inactive statusline
                                     -- and the last window will be drawn as active statusline.
                                     -- for example if you don't want statusline of
                                     -- your file tree / sidebar window to have active
                                     -- statusline you can add their filetypes here.

        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
                                     -- can't take over the entire statusline even
                                     -- if neither of 'x', 'y' or 'z' are present.

        globalstatus = true,         -- enable global statusline (have a single statusline
                                     -- at bottom of neovim instead of one for every window).
                                     -- This feature is only available in neovim 0.7 and higher.

        refresh = {                  -- sets how often lualine should refresh it's contents (in ms)
            statusline = 1000,       -- The refresh option sets minimum time that lualine tries
            tabline = 1000,          -- to maintain between refresh. It's not guarantied if situation
            winbar = 1000            -- arises that lualine needs to refresh itself before this time
                                     -- it'll do it.

                                     -- Also you can force lualine's refresh by calling refresh function
                                     -- like require('lualine').refresh()
        },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(str, _)
                    return string.sub(str, 1, 1)
                end
            },
        },
        lualine_b = {
            "branch"
        },
        lualine_c = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn" },
                symbols = {
                    error = icons.error .. " ",
                    warn = icons.warning .. " ",
                },
                colored = false,
                always_visible = true
            },
        },
        lualine_x = {
            "encoding",
            {
                "filesize",
                separator = { left = " " },
            }
        },
        lualine_y = {
            {
                "filetype",
                colored = false
            },
        },
        lualine_z = {
            {
                "location",
                padding = 0,
            },
        },
    },
}

return {
    "nvim-lualine/lualine.nvim",
    event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine_ok, lualine = pcall(require, "lualine")
        if not lualine_ok then
            vim.notify("Error loading lualine!", vim.log.levels.ERROR)
            return
        end

        -- local plenary_ok, scandir = pcall(require, "plenary.scandir")
        -- if plenary_ok then
        --     local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
        --     local paths = scandir.scan_dir(plugins_path, {
        --         depth = 1,
        --         add_dirs = true,
        --     })
        --
        --     local servers = require("config.servers.langs")
        --
        --     for _, path in ipairs(paths) do
        --         local server_name = string.gsub(path, servers_path .. package.config:sub(1, 1), "")
        --         server_name = server_name:match("([^/]*).lua$")
        --         if server_name ~= "init" and server_name ~= "langs" then
        --             local server = require("config.servers." .. server_name)
        --             if type(server.lang) == "string" then
        --                 servers[server.lang] = server.opts == "ignore" and "ignore" or server_name
        --             else
        --                 for _, lang in ipairs(server.lang) do
        --                     servers[lang] = server.opts == "ignore" and "ignore" or server_name
        --                 end
        --             end
        --         end
        --     end
        -- end
        --
        -- local cmake_tools_ok, _ = pcall(require, "cmake-tools")
        -- if cmake_tools_ok then
        --     local cpp_lualine_ok, cpp_lualine = pcall(require, "plugins.cpp.lualine")
        --     if cpp_lualine_ok then
        --         for _, value in ipairs(cpp_lualine.lualine_c) do
        --             table.insert(lualine_config.sections.lualine_c, value)
        --         end
        --     end
        -- end

        lualine.setup(lualine_config)
    end,
}
