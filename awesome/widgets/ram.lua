local textbox = require("wibox.widget.textbox")
local margin = require("wibox.container.margin")
local watch = require("awful.widget.watch")

local colors = require("colors")


local signal_name = "widgets::ram"

local ram = {}

local function underline(w, color)
  underline_margin = margin(w, 0, 0, 0, 2, color)

  return margin(underline_margin, 0, 0, 2)
end

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

watch(
    'bash -c "free | grep -z Mem.*Swap.*"',
    1,
    function(_, stdout)
        local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
            stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

        local value = used / total * 100

        awesome.emit_signal(signal_name, value)
    end
)

return setmetatable(ram, { __call = function(_, ...) return new(...) end })
