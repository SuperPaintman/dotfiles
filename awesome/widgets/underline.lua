local margin = require("wibox.container.margin")

local underline = {}

local function new(w, color)
    underline_margin = margin(w, 0, 0, 2)

    return margin(underline_margin, 0, 0, 0, 2, color)
end

return setmetatable(underline, { __call = function(_, ...) return new(...) end })
