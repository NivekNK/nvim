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
        { "f", " " .. " Find file", ":Telescope find_files<CR>" },
        { "e", " " .. " New file", ":ene <BAR> startinsert<CR>" },
        { "p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>" },
        { "r", " " .. " Recent files", ":Telescope oldfiles<CR>" },
        { "c", " " .. " Config", ":e $MYVIMRC<CR>" },
        { "q", " " .. " Quit", ":qa<CR>" },
    },
    footer = function()
        return "nivek.me"
    end
}

return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local alpha_ok, alpha = pcall(require, "alpha")
        if not alpha_ok then
            vim.notify("Error loading alpha!", vim.log.levels.ERROR)
            return
        end

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
    end
}
