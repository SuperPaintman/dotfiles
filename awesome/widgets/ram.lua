local wibox = require('wibox')
local margin = require("wibox.container.margin")
local textbox = require("wibox.widget.textbox")

local colors = require("colors")
local underline = require("widgets.underline")
local icon = require("widgets.icon")
local signal_name = require("daemons.ram").signal_name

local ram = {}

local function new()
    local color = colors.normal.blue

    local textbox_widget = textbox("")
    local icon_widget = icon {
        name = "ram",
        color = colors.normal.blue
    }
    local content_widget = wibox.widget{
        margin(icon_widget, 2, 2, 2, 2),
        margin(textbox_widget, 4, 0, 0, 0),
        widget = wibox.layout.fixed.horizontal
    }
    local widget = underline(content_widget, color)

    local function handler(v)
        local markup = string.format("%0.0f%%", v)

        textbox_widget:set_markup(markup)
    end

    handler(0)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

return setmetatable(ram, { __call = function(_, ...) return new(...) end })
