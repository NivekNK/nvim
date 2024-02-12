local utils = require("ccc.utils")
local parse = require("ccc.utils.parse")
local convert = require("ccc.utils.convert")
local pattern = require("ccc.utils.pattern")

local M = {}

---@class NKHslPicker: ColorPicker
M.NKHslPicker = {}

function M.NKHslPicker:init()
    if self.pattern then
        return
    end
    self.pattern = {
        pattern.create("hsla?( [<hue>] , [<number>] , [<number>] %[, [<alpha-value>]]? )"),
    }
end

---@param s string
---@param init? integer
---@return integer? start
---@return integer? end_
---@return RGB?
---@return Alpha?
function M.NKHslPicker:parse_color(s, init)
    self:init()
    init = vim.F.if_nil(init, 1)
    -- The shortest patten is 10 characters like `hsl(0,0,0)`
    while init <= #s - 9 do
        local start, end_, cap1, cap2, cap3, cap4
        for _, pat in ipairs(self.pattern) do
            start, end_, cap1, cap2, cap3, cap4 = pattern.find(s, pat, init)
            if start then
                break
            end
        end
        if not (start and end_ and cap1 and cap2 and cap3) then
            return
        end

        local H = parse.hue(cap1)
        local S = parse.percent(cap2, 100, true)
        local L = parse.percent(cap3, 100, true)
        if H and utils.valid_range({ S, L }, 0, 1) then
            local RGB = convert.hsl2rgb({ H, S, L })
            local A = parse.alpha(cap4)
            return start, end_, RGB, A
        end
        init = end_ + 1
    end
end

return M
