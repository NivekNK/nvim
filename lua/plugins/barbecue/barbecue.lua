local CurrentEntry = {
    winnr = -1
}

local barbecue_state = require("barbecue.ui.state")
local barbecue_ui = require("barbecue.ui")
function CurrentEntry:select_previous_entry()
    if CurrentEntry == -1 then
        vim.notify("[barbecue.barbecue] Entry should not be -1!", vim.log.levels.ERROR)
        return
    end

    local entries = barbecue_state.new(self.winnr):get_entries()
    if entries then
        if #entries > 1 then
            barbecue_ui.navigate(#entries - 1)
        else
            barbecue_ui.navigate(#entries)
        end
    end
end

return CurrentEntry
