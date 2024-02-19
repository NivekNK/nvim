return {
    notifications = {
        function()
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.extensions.notify.notify()
            else
                vim.cmd("Notifications")
            end
        end, "Notifications"
    },
}
