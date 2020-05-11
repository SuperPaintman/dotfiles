local textbox = require("wibox.widget.textbox")
local margin = require("wibox.container.margin")
local watch = require("awful.widget.watch")

local colors = require("colors")


local signal_name = "widgets::cpu"

local cpu = {}

local function underline(w, color)
  underline_margin = margin(w, 0, 0, 0, 2, color)

  return margin(underline_margin, 0, 0, 2)
end

local function new(args)
    local color = colors.normal.red

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(v)
        local markup = string.format("<span foreground='%s'><b>CPU</b></span>  %0.0f%%", color, v)

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

local total_prev = 0
local idle_prev = 0
watch(
    [[bash -c "cat /proc/stat | grep '^cpu '"]],
    3,
    function(_, stdout)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
            stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

        awesome.emit_signal(signal_name, diff_usage)

        total_prev = total
        idle_prev = idle
    end
)

return setmetatable(cpu, { __call = function(_, ...) return new(...) end })
