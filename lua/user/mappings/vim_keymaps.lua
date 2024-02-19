local Utils = require("user.utils")

local commands = {}

commands.n = {
    save_file = ":w<CR>",
    resize_panel_up = ":resize +2<CR>",
    resize_panel_down = ":resize -2<CR>",
    resize_panel_left = ":vertical resize -2<CR>",
    resize_panel_right = ":vertical resize +2<CR>",
    select_all_text = "gg0vG$",
    black_hole = '"_',
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

        local open_cmd = Utils.is_windows() and 'cmd.exe /c start ""' or "xdg-open"
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

commands.i = {
    escape_alternative = "<ESC>",
    save_file = "<ESC>:w<CR>i",
    move_text_up = "<ESC>:m .-2<CR>i",
    move_text_down = "<ESC>:m .+1<CR>i",
}

commands.v = {
    indent_left = "<gv",
    indent_right = ">gv",
    better_paste = '"_dP',
}

commands.x = {}

return commands
