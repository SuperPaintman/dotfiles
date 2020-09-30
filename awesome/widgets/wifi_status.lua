local textbox = require("wibox.widget.textbox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local colors = require("colors")
local underline = require("widgets.underline")


local signal_name = "widgets::wifi"

local status_connected = "connected"
local status_disconnected = "disconnected"

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

    local function handler(status, wifi_name, wifi_signal)
        local color = color_disconnected
        local markup = ""
        local error

        if status == status_connected then
            color = color_connected
            markup = string.format("<span foreground='%s'><b>WIFI</b></span>  <span foreground='%s'>%s</span>  %s%%", color_connected_marker, color_connected, wifi_name, wifi_signal)
        elseif status == status_disconnected then
            color = color_disconnected
            markup = string.format("<span foreground='%s'><b>WIFI</b></span>", color_disconnected_marker)
        else
            color = color_error
            markup = string.format("<span foreground='%s'><b>WIFI ERROR</b></span>", color_error_marker)
            error = "Unknown Wifi status (" .. status .. ")"
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
    os.getenv("HOME") .. "/bin/wifistatus",
    10,
    function(_, stdout, _, _, exitcode)
        if exitcode ~= 0 then
            awesome.emit_signal(signal_name, "bad exit code (" .. tostring(exitcode) .. ")")
            return
        end

        local status, wifi_name, wifi_signal = stdout:match('(%w+)%s+([^%s]+)%s+([0-9]+)')

        if status == nil then
            if stdout:match("disconnected") then
                awesome.emit_signal(signal_name, status_disconnected)
            else
                awesome.emit_signal(signal_name, "<nil>")
            end

            return
        end

        awesome.emit_signal(signal_name, status, wifi_name, wifi_signal)
    end
)

return setmetatable(wifi_status, { __call = function(_, ...) return new(...) end })
