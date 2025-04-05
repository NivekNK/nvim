Clue = Clue or {
    groups = {},
    modifiables = {},
    filetypes = {},
}

---@param keymap string
---@param command string|function
---@param description string
---@param filetype? "*"|"mod"|table|string
---@param excluded? string[]
function Clue:nmap(keymap, command, description, filetype, excluded)
    if not filetype or (filetype == "*" and not excluded) or (filetype == "*" and excluded and #excluded == 0) then
        vim.keymap.set("n", keymap, command, {
            desc = description,
        })
    elseif filetype == "*" then
        if not self.filetypes[filetype] then
            self.filetypes[filetype] = {}
        end
        table.insert(self.filetypes[filetype], {
            keymap = keymap,
            command = command,
            description = description,
            excluded = excluded,
        })
    elseif filetype == "mod" then
        table.insert(self.modifiables, {
            keymap = keymap,
            command = command,
            description = description,
            excluded = excluded,
        })
    elseif type(filetype) == "table" then
        for _, p in ipairs(filetype) do
            if not self.filetypes[p] then
                self.filetypes[p] = {}
            end
            table.insert(self.filetypes[p], {
                keymap = keymap,
                command = command,
                description = description,
                excluded = excluded,
            })
        end
    else
        if not self.filetypes[filetype] then
            self.filetypes[filetype] = {}
        end
        table.insert(self.filetypes[filetype], {
            keymap = keymap,
            command = command,
            description = description,
            excluded = excluded,
        })
    end
end

function Clue:apply()
    print(vim.inspect(self))

    vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
        pattern = { "*" },
        callback = function()
            -- Get the current buffer number
            local bufnr = vim.api.nvim_get_current_buf()
            local is_modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable")
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

            if is_modifiable and filetype ~= "" then
                for _, mapping in ipairs(self.modifiables) do
                    local is_excluded = vim.tbl_contains(mapping.excluded or {}, filetype)
                    if not is_excluded then
                        -- Set buffer-local keymaps
                        vim.keymap.set("n", mapping.keymap, mapping.command, {
                            buffer = bufnr, -- Make it buffer-local
                            desc = mapping.description,
                        })
                    end
                end
            end
        end
    })

    for k, v in pairs(self.filetypes) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { k },
            callback = function()
                -- Get the current buffer number
                local bufnr = vim.api.nvim_get_current_buf()
                for _, mapping in ipairs(v) do
                    if mapping.excluded then
                        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                        local is_excluded = vim.tbl_contains(mapping.excluded, filetype)
                        if not is_excluded then
                            -- Set buffer-local keymaps
                            vim.keymap.set("n", mapping.keymap, mapping.command, {
                                buffer = bufnr, -- Make it buffer-local
                                desc = mapping.description,
                            })
                        end
                    else
                        vim.keymap.set("n", mapping.keymap, mapping.command, {
                            buffer = bufnr, -- Make it buffer-local
                            desc = mapping.description,
                        })
                    end
                end
            end
        })
    end
end

---@param mode "n"|"x"
---@param keymap string
---@param name string
function Clue:add_group(mode, keymap, name)
    table.insert(self.groups, {
        mode = mode,
        keys = keymap,
        desc = "+" .. name,
    })
end

return Clue
