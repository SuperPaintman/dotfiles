--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local wibox = require("wibox")
local gears = require("gears")

local icons = require("icons")


--------------------------------------------------------------------------------
-- Widget.
--------------------------------------------------------------------------------
local icon = {}

function icon:set_color(value)
    if self._private.base_image == nil then
        return
    end

    if value == nil then
        self.image = self._private.base_image
        return
    end

    if self._private.recolored_cache[value] ~= nil then
        self.image = self._private.recolored_cache[value]
        return
    end

    local result = gears.color.recolor_image(self._private.base_image, value)

    self._private.recolored_cache[value] = result

    self.image = result
end

local function new(args)
    local name = args.name
    local color = args.color

    local image = icons[name]

    local widget = wibox.widget {
        image = image,
        resize = true,
        widget = wibox.widget.imagebox
    }

    gears.table.crush(widget, icon, true)

    -- Initial image.
    widget._private.base_image = image

    -- Cache for recolored images.
    widget._private.recolored_cache = {}

    widget:set_color(color)

    return widget
end

return setmetatable(icon, { __call = function(_, ...) return new(...) end })
