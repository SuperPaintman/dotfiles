local textbox = require("wibox.widget.textbox")

local colors = require("colors")
local underline = require("widgets.underline")
local wifi_status_daemon = require("daemons.wifi_status")

local signal_name = wifi_status_daemon.signal_name

local wifi_status = {}

local function new(args)
    local color_connected = colors.normal.green
    local color_disconnected = colors.normal.red
    local color_error = colors.normal.red

    local color_connected_marker = colors.normal.green
    local color_disconnected_marker = colors.normal.red
    local color_error_marker = colors.normal.red

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color_disconnected)

    local function handler(status, name, signal)
        local color = color_disconnected
        local markup = ""

        if status == wifi_status_daemon.status_connected then
            color = color_connected
            markup = string.format("<span foreground='%s'><b>WIFI</b></span>  <span foreground='%s'>%s</span>  %s%%", color_connected_marker, color_connected, name, signal)
        elseif status == wifi_status_daemon.status_disconnected then
            color = color_disconnected
            markup = string.format("<span foreground='%s'><b>WIFI</b></span>", color_disconnected_marker)
        elseif status == wifi_status_daemon.status_error then
            color = color_error
            markup = string.format("<span foreground='%s'><b>WIFI ERROR</b></span>", color_error_marker)
        else
            color = color_error
            markup = string.format("<span foreground='%s'><b>WIFI UNKNOWN STATUS</b></span>", color_error_marker)
        end

        textbox_widget:set_markup(markup)
        widget:set_color(color)
    end

    handler(wifi_status_daemon.status_disconnected, "", 0)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

return setmetatable(wifi_status, { __call = function(_, ...) return new(...) end })
