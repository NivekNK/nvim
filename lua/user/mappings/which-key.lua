local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("[mappings] Error loading which-key!", vim.log.levels.ERROR)
    return
end
