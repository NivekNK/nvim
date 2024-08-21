local Utils = require("user.utils")

if Utils.is_windows() then
    vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
    vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
end

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

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("Error loading lazy!", vim.log.levels.ERROR)
    return
end

lazy.setup("plugins")

-- Set spell languages
local function download_spell_file(lang)
    local destination = vim.fn.stdpath('data') .. "/site/spell/" .. lang .. ".utf-8.spl"

    -- Check if the spell file already exists
    local file_exists = vim.loop.fs_stat(destination)

    if not file_exists then
        -- Create the directory if it doesn't exist
        vim.fn.mkdir(vim.fn.stdpath('data') .. "/site/spell", "p")

        -- URL for downloading the spell file
        local url = "http://ftp.vim.org/pub/vim/runtime/spell/" .. lang .. ".utf-8.spl"

        -- Download the spell file using curl
        local cmd = "curl -o " .. destination .. " " .. url

        local result = os.execute(cmd)

        -- Check if the download was successful
        if result ~= 0 then
            vim.notify("Error downloading spell file for " .. lang .. ": " .. result, vim.log.levels.ERROR)
            os.remove(destination)  -- Delete the partially downloaded file
        else
            vim.notify("Downloaded spell file for " .. lang)
        end
    end
end

local langs = { "en", "es" }

for _, lang in ipairs(langs) do
    download_spell_file(lang)
end

