local function get_opts()
    local schemastore_ok, schemastore = pcall(require, "schemastore")
    if not schemastore_ok then
        vim.notify("[servers.jsonls] Error loading schemastore!", vim.log.levels.WARN)
        return "ignore"
    end

    return {
        settings = {
            json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
            },
        },
        setup = {
            commands = {
                Format = {
                    function()
                        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                    end,
                },
            },
        },
    }
end

return {
    lang = "json",
    opts = get_opts()
}
