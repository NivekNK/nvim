local Utils = require("nk.utils")

if Utils.is_windows() then
    vim.opt.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
    vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
end

require("config.vim")

local diagnostic = require("config.diagnostic")

vim.fn.sign_define("DiagnosticSignError", {
    texthl = "DiagnosticSignError",
    text = diagnostic.signs_icons.error,
    numhl = "",
})

vim.fn.sign_define("DiagnosticSignWarn", {
    texthl = "DiagnosticSignWarn",
    text = diagnostic.signs_icons.warning,
    numhl = "",
})

vim.fn.sign_define("DiagnosticSignInfo", {
    texthl = "DiagnosticSignInfo",
    text = diagnostic.signs_icons.info,
    numhl = "",
})

vim.fn.sign_define("DiagnosticSignHint", {
    texthl = "DiagnosticSignHint",
    text = diagnostic.signs_icons.hint,
    numhl = "",
})

vim.diagnostic.config({
    virtual_text = diagnostic.virtual_text,
    signs = {
        active = {
            { name = "DiagnosticSignError", text = diagnostic.signs_icons.error },
            { name = "DiagnosticSignWarn",  text = diagnostic.signs_icons.warning },
            { name = "DiagnosticSignInfo",  text = diagnostic.signs_icons.info },
            { name = "DiagnosticSignHint",  text = diagnostic.signs_icons.hint },
        }
    },
    update_in_insert = diagnostic.update_in_insert,
    underline = diagnostic.underline,
    severity_sort = diagnostic.severity_sort,
    float = diagnostic.float,
})

require("config.commands")

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazy_path)

local ok, lazy = pcall(require, "lazy")
if not ok then
    Utils.notify_error("Error loading lazy!")
    return
end

lazy.setup("plugins")

local function download_spell_file(lang)
    local destination = vim.fn.stdpath("data") .. "/site/spell/" .. lang .. ".utf-8.spl"

    -- Check if the spell file already exists
    local file_exists = vim.loop.fs_stat(destination)

    if not file_exists then
        -- Create the directory if it doesn't exist
        vim.fn.mkdir(vim.fn.stdpath("data") .. "/site/spell", "p")

        -- URL for downloading the spell file
        local url = "https://ftp.nluug.nl/pub/vim/runtime/spell/" .. lang .. ".utf-8.spl"

        -- Download the spell file using curl
        local cmd = "curl -o " .. destination .. " " .. url

        local result = os.execute(cmd)

        -- Check if the download was successful
        if result ~= 0 then
            Utils.notify_error("Error downloading spell file for " .. lang .. ": " .. result)
            os.remove(destination)  -- Delete the partially downloaded file
        else
            Utils.notify("Downloaded spell file for " .. lang)
        end
    end
end

local localization = require("config.localization")

Utils.notify("Checking spell files...")
for _, lang in ipairs(localization) do
    download_spell_file(lang)
end
Utils.notify("Spell files ready!")

Utils.foreach_filename("/config/keymaps", function(keymap)
    keymap = "config.keymaps." .. keymap
    ok, _ = pcall(require, keymap)
    if not ok then
        Utils.notify_error("Failed to load [" .. keymap .. "] keymap.")
    end
end)
