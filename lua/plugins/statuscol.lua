local function get_statuscol_config(builtin)
return {
    relculright = true,
    segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
    },
}
end

return {
    "luukvbaal/statuscol.nvim",
    config = function()
        local statuscol_ok, statuscol = pcall(require, "statuscol")
        if not statuscol_ok then
            vim.notify("[ufo] Error loading statuscol!", vim.log.levels.ERROR)
            return
        end

        local config = get_statuscol_config(require("statuscol.builtin"))
        statuscol.setup(config)
    end,
}
