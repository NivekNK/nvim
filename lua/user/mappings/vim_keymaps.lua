local commands = {}

commands.n = {
	save_file = ":w<CR>",
	resize_panel_up = ":resize +2<CR>",
	resize_panel_down = ":resize -2<CR>",
	resize_panel_left = ":vertical resize -2<CR>",
	resize_panel_right = ":vertical resize +2<CR>",
	move_text_up = "<ESC>:m .-2<CR>",
	move_text_down = "<ESC>: m .+1<CR>",
	select_all_text = "ggvG",
	-- NOTE: Stoled from https://github.com/xiyaowong/link-visitor.nvim
	open_link = function()
		local pattern =
			"\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*\\})\\})+"
		local line = vim.api.nvim_get_current_line()

		local links = {}

		local link = ""
		local last = 0
		local first = 0
		while true do
			link, first, last = unpack(vim.fn.matchstrpos(line, pattern, last))
			link = vim.trim(link)
			if link == "" then
				break
			end
			table.insert(links, {
				link = link,
				first = first,
				last = last,
			})
		end

		local uname = vim.loop.os_uname()
		local os = uname.sysname
		local open_cmd
		if os:find("Windows") or (os == "Linux" and uname.release:lower():find("microsoft")) then
			open_cmd = 'cmd.exe /c start ""'
		else
			open_cmd = "xdg-open"
		end

		if #links > 0 then
			local col = vim.fn.col(".")
			for _, current_link in ipairs(links) do
				if col >= current_link.first and col <= current_link.last then
					vim.fn.jobstart(string.format("%s %s", open_cmd, current_link.link), {
						on_stderr = function(_, data)
							local msg = table.concat(data or {}, "\n")
							if msg ~= "" then
								vim.notify(string.format("Error trying to open a link: %s", msg), vim.log.levels.ERROR)
							end
						end,
					})
				end
			end
			return
		end
		vim.notify("Link not found!", vim.log.levels.INFO)
	end,
}
-- https://www.reddit.com/r/neovim/comments/ro6oye/open_link_from_neovim/
commands.i = {
	escape_alternative = "<ESC>",
	save_file = "<ESC>:w<CR><i>",
	move_text_up = "<ESC>:m .-2<CR><a>",
	move_text_down = "<ESC>:m .+1<CR><a>",
}

commands.v = {
	indent_left = "<gv",
	indent_right = ">gv",
	move_text_up = ":m .-1<CR>==",
	move_text_down = ":m .+1<CR>==",
	better_paste = '"_dP',
}

commands.x = {
	move_text_up = ":move '<-2<CR>gv-gv",
	move_text_down = ":move '>+1<CR>gv-gv",
}

return commands
