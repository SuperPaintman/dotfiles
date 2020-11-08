local textbox = require("wibox.widget.textbox")

local colors = require("colors")
local underline = require("widgets.underline")
local signal_name = require("daemons.ram").signal_name

local ram = {}

local function new()
    local color = colors.normal.blue

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(v)
        local markup = string.format("<span foreground='%s'><b>RAM</b></span>  %0.0f%%", color, v)

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
