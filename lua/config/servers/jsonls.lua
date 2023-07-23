return {
	lang = "json",
	opts = function()
		local schemastore_ok, schemastore = pcall(require, "schemastore")
		if not schemastore_ok then
			vim.notify("[config.servers.jsonls] Error >> schemastore not found!", vim.log.levels.WARN)
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
	end,
}
