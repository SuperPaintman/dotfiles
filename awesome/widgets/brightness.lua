local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")

local underline = require("widgets.underline")
local brightness_daemon = require("daemons.brightness")

local signal_name = brightness_daemon.signal_name

local brightness = {}

local function new(args)
    local color = beautiful.widget_brightness_color or beautiful.widget_color or beautiful.fg_normal or "#FFFFFF"

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(success, err)
        if err ~= nil then
            return
        end

        local markup = string.format("<span foreground='%s'><b>BRI</b></span>  %d%%", color, success.level * 100)

        textbox_widget:set_markup(markup)
        widget:set_color(color)
    end

    handler({ level = 0 })

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

return setmetatable(brightness, { __call = function(_, ...) return new(...) end })
