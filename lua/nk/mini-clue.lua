Clue = Clue or {
    buffer_patterns = {}
}

---@param keymap string
---@param command string|function
---@param description string
---@param pattern? "global"|"mod"|table|string
---@param excluded? string[]
function Clue:nmap(keymap, command, description, pattern, excluded)
    if not pattern then
        vim.keymap.set("n", keymap, command, {
            desc = description,
        })
        return
    end

    if pattern == "global" or pattern == "mod" then
        -- TODO: add condition for excluded types
        vim.keymap.set("n", keymap, command, {
            desc = description,
        })
    elseif type(pattern) == "table" then
        for _, p in ipairs(pattern) do
            if not self.buffer_patterns[p] then
                self.buffer_patterns[p] = {}
            end
            table.insert(self.buffer_patterns[p], {
                keymap = keymap,
                command = command,
                description = description,
            })
        end
    else
        if not self.buffer_patterns[pattern] then
            self.buffer_patterns[pattern] = {}
        end
        table.insert(self.buffer_patterns[pattern], {
            keymap = keymap,
            command = command,
            description = description,
        })
    end
end

function Clue:apply()
    for k, v in pairs(self.buffer_patterns) do
        for _, mapping in ipairs(v) do
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = k,
                callback = function()
                    -- Get the current buffer number
                    local bufnr = vim.api.nvim_get_current_buf()

                    -- Set buffer-local keymaps
                    vim.keymap.set("n", mapping.keymap, mapping.command, {
                        buffer = bufnr, -- Make it buffer-local
                        desc = mapping.description,
                    })
                end
            })
        end
    end
end

return Clue
