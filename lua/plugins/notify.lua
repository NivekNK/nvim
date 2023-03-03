local function setup()
    local status_ok, notify = pcall(require, "notify")
    if not status_ok then
        vim.notify("Error loading notify!", vim.log.levels.ERROR)
        return
    end

    -- TODO: Move icons to a separated file.
    notify.setup({
        background_colour = "Normal",
        fps = 30,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "compact",
        stages = "fade",
        timeout = 5000,
        top_down = true
    })

    vim.notify = notify
end

return {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 900,
    config = setup
}
