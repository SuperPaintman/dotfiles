local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")

local underline = require("widgets.underline")
local volume_daemon = require("daemons.volume")

local signal_name = volume_daemon.signal_name

local volume = {}

local function new(args)
    local color_unmuted = beautiful.widget_volume_color or beautiful.widget_color or beautiful.fg_normal or "#FFFFFF"
    local color_muted = beautiful.widget_volume_muted_color or beautiful.widget_color or beautiful.fg_normal or "#FFFFFF"

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color_muted)

    local function handler(success, err)
        if err ~= nil then
            return
        end

        local color = color_muted
        local markup = ""

        if success.muted then
            color = color_muted
            markup = string.format("<span foreground='%s'><b>VOL MUTED</b></span>  %d%%", color, success.volume * 100)
        else
            color = color_unmuted
            markup = string.format("<span foreground='%s'><b>VOL</b></span>  %d%%", color, success.volume * 100)
        end

        textbox_widget:set_markup(markup)
        widget:set_color(color)
    end

    handler({ muted = false, volume = 0 })

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

return setmetatable(volume, { __call = function(_, ...) return new(...) end })
