local awful = require("awful")
local textbox = require("wibox.widget.textbox")
local gears = require("gears")

local colors = require("colors")
local underline = require("widgets.underline")
local apps = require("apps")
local vpn_status_daemon = require("daemons.vpn_status")

local signal_name = vpn_status_daemon.signal_name

local vpn_status = {}

local function new(args)
    local color_connected = colors.normal.green
    local color_connecting = colors.normal.red
    local color_disconnected = colors.normal.red
    local color_error = colors.normal.red

    local color_connected_marker = colors.normal.green
    local color_connecting_marker = colors.normal.green
    local color_disconnected_marker = colors.normal.red
    local color_error_marker = colors.normal.red

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color_disconnected)

    local function handler(status, name, ip)
        local color = color_disconnected
        local markup = ""
        local error

        name = gears.string.xml_escape(name)

        if status == vpn_status_daemon.status_connected then
            color = color_connected
            markup = string.format("<span foreground='%s'><b>VPN</b></span>  %s  <span foreground='%s'>%s</span>", color_connected_marker, ip, color_connected, name)
        elseif status == vpn_status_daemon.status_connecting then
            color = color_connecting
            markup = string.format("<span foreground='%s'><b>VPN</b></span>  %s  <span foreground='%s'>%s</span>", color_connecting_marker, ip, color_connecting, name)
        elseif status == vpn_status_daemon.status_disconnected then
            color = color_disconnected
            markup = string.format("<span foreground='%s'><b>VPN</b></span>", color_disconnected_marker)
        else
            color = color_error
            markup = string.format("<span foreground='%s'><b>VPN ERROR</b></span>", color_error_marker)
            error = "Unknown VPN status (" .. status .. ")"
        end

        textbox_widget:set_markup(markup)
        widget:set_color(color)
    end

    handler(vpn_status_daemon.status_disconnected, "", "")

    widget:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                apps.vpnmenu()
            end)
        )
    )
    widget:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = "hand1"
        end
    end)
    widget:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = "left_ptr"
        end
    end)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

return setmetatable(vpn_status, { __call = function(_, ...) return new(...) end })
