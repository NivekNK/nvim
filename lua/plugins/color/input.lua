local ColorInput = require("ccc.input")
-- local utils = require("ccc.utils")
local convert = require("ccc.utils.convert")

local M = {}

---@class NKHslInput: ColorInput
M.NKHslInput = setmetatable({
    name = "HSL (,)",
    max = { 360, 100, 100 },
    min = { 0, 0, 0 },
    delta = { 1, 1, 1 },
    bar_name = { "H", "S", "L" },
}, { __index = ColorInput })

---@param n number
----@param i integer
---@return string
function M.NKHslInput.format(n, _)
    return ("%6d"):format(n)
end

---@param RGB RGB
---@return HSL
function M.NKHslInput.from_rgb(RGB)
    local h, s, l = unpack(convert.rgb2hsl(RGB))
    return { h, s * 100, l * 100 }
end

---@param HSL HSL
---@return RGB
function M.NKHslInput.to_rgb(HSL)
    local h, s, l = unpack(HSL)
    return convert.hsl2rgb({ h, s * 0.01, l * 0.01 })
end

return M
