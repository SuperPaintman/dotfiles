local margin = require("wibox.container.margin")
local dpi = require("beautiful.xresources").apply_dpi

local underline = {}

local function new(w, color)
    local underline_margin = margin(w, 0, 0, dpi(2))

    return margin(underline_margin, 0, 0, 0, dpi(2), color)
end

return setmetatable(underline, { __call = function(_, ...) return new(...) end })
