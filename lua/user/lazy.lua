require("config.vim")

-- Set diagnostics
local diagnostic = require("config.diagnostic")
for _, sign in ipairs(diagnostic.signs.active) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
vim.diagnostic.config(diagnostic)

require("config.commands")

-- Automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	vim.notify("Error loading lazy!", vim.log.levels.ERROR)
	return
end

lazy.setup("plugins")
