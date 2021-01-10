local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")

local underline = require("widgets.underline")
local signal_name_status = require("daemons.battery").signal_name_status

local battery = {}

local function new(args)
    local color = beautiful.widget_battery_color or beautiful.widget_color or beautiful.fg_normal or "#FFFFFF"

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(v)
        local markup = string.format("<span foreground='%s'><b>BAT</b></span>  %0.0f%%", color, v)

        textbox_widget:set_markup(markup)
    end

    handler(0)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name_status, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name_status, handler)

    return widget
end

return setmetatable(battery, { __call = function(_, ...) return new(...) end })
