local copilot_config = {
    filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 16.x
    server_opts_overrides = {},
}

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            local copilot_ok, copilot = pcall(require, "copilot")
            if not copilot_ok then
                vim.notify("[copilot] Error loading copilot!", vim.log.levels.ERROR)
                return
            end
            copilot_config = vim.tbl_deep_extend("force", copilot_config, {
                panel = { enabled = false },
                suggestion = { enabled = false },
            })
            copilot.setup(copilot_config)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function ()
            local copilot_cmp_ok, copilot_cmp = pcall(require, "copilot_cmp")
            if not copilot_cmp_ok then
                vim.notify("[copilot] Error loading copilot_cmp!", vim.log.levels.ERROR)
                return
            end
            copilot_cmp.setup()
        end,
    },
}
