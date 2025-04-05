local Utils = require("nk.utils")

local ok, oil = pcall(require, "oil")
if not ok then
    Utils.notify_error("Failed to load oil plugin.")
    return
end

local Clue = require("nk.mini-clue")

Clue:nmap("<leader>V", function()
    oil.select({
        vertical = true,
    })
end, "Explorer Vertical Split", "oil")

Clue:nmap("<leader>e", ":Oil<CR>", "Explorer", "mod")
