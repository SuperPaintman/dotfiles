local wibox = require('wibox')
local margin = require("wibox.container.margin")
local textbox = require("wibox.widget.textbox")

local colors = require("colors")
local underline = require("widgets.underline")
local icon = require("widgets.icon")
local signals = require("daemons.monitroid").signals

local cpu = {}

local function new(args)
    local color = colors.normal.red

    local textbox_widget = textbox("")
    local icon_widget = icon {
        name = "cpu",
        color = colors.normal.red
    }
    local content_widget = wibox.widget{
        margin(icon_widget, 2, 2, 2, 2),
        margin(textbox_widget, 4, 0, 0, 0),
        widget = wibox.layout.fixed.horizontal
    }
    local widget = underline(content_widget, color)

    local function handler(success, err)
        if err ~= nil then
            return
        end

        local markup = string.format("%0.0f%%", success.usage * 100)

        textbox_widget:set_markup(markup)
    end

    handler({ usage = 0 })

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signals.cpu, handler)
    --   end
    -- })

    awesome.connect_signal(signals.cpu, handler)

    return widget
end

return setmetatable(cpu, { __call = function(_, ...) return new(...) end })
