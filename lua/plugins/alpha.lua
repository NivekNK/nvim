local Utils = require("user.utils")

local drop_config = {
    theme = "stars",                                 -- can be one of rhe default themes, or a custom theme
    max = 40,                                        -- maximum number of drops on the screen
    interval = 150,                                  -- every 150ms we update the drops
    screensaver = 1000 * 60 * 5,                         -- show after 5 minutes. Set to false, to disable
    filetypes = { "dashboard", "alpha", "starter" }, -- will enable/disable automatically for the following filetypes
}

local alpha_config = {
    header = {
        '',
        '',
        '          ::::    ::: :::    ::: :::     ::: :::::::::::   :::   ::: ',
        '         :+:+:   :+: :+:   :+:  :+:     :+:     :+:      :+:+: :+:+: ',
        '        :+:+:+  +:+ +:+  +:+   +:+     +:+     +:+     +:+ +:+:+ +:+ ',
        '       +#+ +:+ +#+ +#++:++    +#+     +:+     +#+     +#+  +:+  +#+  ',
        '      +#+  +#+#+# +#+  +#+    +#+   +#+      +#+     +#+       +#+   ',
        '     #+#   #+#+# #+#   #+#    #+#+#+#       #+#     #+#       #+#    ',
        '    ###    #### ###    ###     ###     ########### ###       ###     ',
        '',
        '',
    },
    buttons = {
        { "f", " " .. " Find file",    ":Telescope find_files<CR>" },
        { "e", " " .. " New file",     ":ene <BAR> startinsert<CR>" },
        { "p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>" },
        { "r", " " .. " Recent files", ":Telescope oldfiles<CR>" },
        { "c", " " .. " Config",       ":e $MYVIMRC<CR>" },
        { "q", " " .. " Quit",         ":qa<CR>" },
    },
    footer = function()
        return "nivek.tech"
    end
}

return {
    {
        "folke/drop.nvim",
        event = "VimEnter",
        config = function()
            Utils.callback_if_ok_msg("drop", function(drop)
                drop.setup(drop_config)
            end)
        end,
    },
    {
        "goolord/alpha-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            Utils.callback_if_ok_msg("alpha", function(alpha)
                local dashboard = require("alpha.themes.dashboard")
                dashboard.section.header.val = alpha_config.header

                local buttons = {}
                for i, v in ipairs(alpha_config.buttons) do
                    buttons[i] = dashboard.button(v[1], v[2], v[3])
                end
                dashboard.section.buttons.val = buttons

                dashboard.section.footer.val = alpha_config.footer()
                dashboard.section.footer.opts.hl = "Type"
                dashboard.section.header.opts.hl = "Include"
                dashboard.section.buttons.opts.hl = "Keyword"
                dashboard.opts.opts.noautocmd = true

                alpha.setup(dashboard.opts)
            end)
        end,
    }
}
