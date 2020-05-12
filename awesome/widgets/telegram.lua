local textbox = require("wibox.widget.textbox")
local watch = require("awful.widget.watch")

local colors = require("colors")
local underline = require("widgets.underline")


local signal_name = "widgets::telegram"

local telegram = {}

local function new()
    local color = colors.normal.blue

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(unread_count)
        local markup = string.format("<span foreground='%s'><b>TG</b></span>  %d", color, unread_count)

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

watch(
    os.getenv("HOME") .. "/bin/telegramstatus",
    1,
    function(_, stdout, _, _, exitcode)
        if exitcode ~= 0 then
            awesome.emit_signal(signal_name)
            return
        end

        local unread_count = stdout:match('(%d+)')

        awesome.emit_signal(signal_name, unread_count)
    end
)

return setmetatable(telegram, { __call = function(_, ...) return new(...) end })
