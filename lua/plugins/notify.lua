local icons = require("config.icons")

local config = {
    background_colour = "Normal",
    fps = 30,
    icons = {
        DEBUG = icons.debug,
        ERROR = icons.error,
        INFO = icons.info,
        TRACE = icons.trace,
        WARN = icons.warning
    },
    level = 2,
    minimum_width = 50,
    render = "compact",
    stages = "fade",
    timeout = 5000,
    top_down = true
}

return {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 900,
    config = function()
        local status_ok, notify = pcall(require, "notify")
        if not status_ok then
            vim.notify("Error loading notify!", vim.log.levels.ERROR)
            return
        end

        notify.setup(config)
        vim.notify = notify
    end
}
