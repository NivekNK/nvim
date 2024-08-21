local M = {}

---@param wk wk
function M.setup(wk)
    wk.add({
        {
            "<leader>s",
            group = "Search",
            buffer = true,
        },
        {
            "<leader>sn",
            function()
                local ok, telescope = pcall(require, "telescope")
                if ok then
                    telescope.extensions.notify.notify()
                else
                    vim.cmd("Notifications")
                end
            end,
            desc = "Notifications",
            buffer = true,
        }
    })
end

return M
