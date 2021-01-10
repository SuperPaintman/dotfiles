local beautiful = require("beautiful")
local wibox = require('wibox')
local margin = require("wibox.container.margin")
local textbox = require("wibox.widget.textbox")

local underline = require("widgets.underline")
local signals = require("daemons.monitroid").signals

local disk = {}

local function new()
    local color = beautiful.widget_disk_color or beautiful.widget_color or beautiful.fg_normal or "#FFFFFF"

    local textbox_widget = textbox("")
    local content_widget = wibox.widget{
        margin(textbox_widget, 4, 0, 0, 0),
        widget = wibox.layout.fixed.horizontal
    }
    local widget = underline(content_widget, color)

    local function handler(success, err)
        if err ~= nil then
            return
        end

        local markup = string.format("<span foreground='%s'><b>DISK</b></span>  %0.0f%%", color, success.usage * 100)

        textbox_widget:set_markup(markup)
    end

    handler({ usage = 0 })

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signals.disk, handler)
    --   end
    -- })

    awesome.connect_signal(signals.disk, handler)

    return widget
end

return setmetatable(disk, { __call = function(_, ...) return new(...) end })
