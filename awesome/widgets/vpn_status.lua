local textbox = require("wibox.widget.textbox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local colors = require("colors")
local underline = require("widgets.underline")


local signal_name = "widgets::vpn"

local status_connected = "connected"
local status_connecting = "connecting"
local status_disconnected = "disconnected"

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

    local function handler(status, vpn_name, vpn_ip)
        local color = color_disconnected
        local markup = ""
        local error

        if status == status_connected then
            color = color_connected
            markup = string.format("<span foreground='%s'><b>VPN</b></span>  %s  <span foreground='%s'>%s</span>", color_connected_marker, vpn_ip, color_connected, vpn_name)
        elseif status == status_connecting then
            color = color_connecting
            markup = string.format("<span foreground='%s'><b>VPN</b></span>  %s  <span foreground='%s'>%s</span>", color_connecting_marker, vpn_ip, color_connecting, vpn_name)
        elseif status == status_disconnected then
            color = color_disconnected
            markup = string.format("<span foreground='%s'><b>VPN</b></span>", color_disconnected_marker)
        else
            color = color_error
            markup = string.format("<span foreground='%s'><b>VPN ERROR</b></span>", color_error_marker)
            error = "Unknown VPN status (" .. status .. ")"
        end

        textbox_widget:set_markup(markup)
        widget:set_color(color)

        assert(error == nil, error)
    end

    handler(status_disconnected)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

watch(
    os.getenv("HOME") .. "/bin/vpnstatus",
    1,
    function(_, stdout, _, _, exitcode)
        if exitcode ~= 0 then
            awesome.emit_signal(signal_name, "bad exit code (" .. tostring(exitcode) .. ")")
            return
        end

        local status, vpn_name, vpn_ip = stdout:match('(%w+)%s+([^%s]+)%s+([0-9\\.]+)')

        if status == nil then
            if stdout:match("disconnected") then
                awesome.emit_signal(signal_name, status_disconnected)
            else
                awesome.emit_signal(signal_name, "<nil>")
            end

            return
        end

        awesome.emit_signal(signal_name, status, vpn_name, vpn_ip)
    end
)

return setmetatable(vpn_status, { __call = function(_, ...) return new(...) end })
