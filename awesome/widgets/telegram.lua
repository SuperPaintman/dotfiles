local awful = require("awful")
local textbox = require("wibox.widget.textbox")
local watch = require("awful.widget.watch")

local colors = require("colors")
local underline = require("widgets.underline")


local signal_name = "widgets::telegram"

local telegram = {}

local function new()
    local color = colors.normal.blue
    local color_diff = colors.normal.green

    local textbox_widget = textbox("")
    local widget = underline(textbox_widget, color)

    local function handler(unread_count, unread_count_diff)
        local markup = ""

        if unread_count_diff > 0 then
            markup = string.format("<span foreground='%s'><b>TG</b></span>  %d (<span foreground='%s'>+%d</span>)", color, unread_count, color_diff, unread_count_diff)
        else
            markup = string.format("<span foreground='%s'><b>TG</b></span>  %d", color, unread_count)
        end

        textbox_widget:set_markup(markup)
    end

    handler(0, 0)

    -- setmetatable(widget, {
    --   __gc = function()
    --     awesome.disconnect_signal(signal_name, handler)
    --   end
    -- })

    awesome.connect_signal(signal_name, handler)

    return widget
end

-- We try detect a new unread messages and show a diff with a previous "seen"
-- count.
local is_telegram_focused = false
local unread_count_prev = 0
-- NOTE(SuperPaintman):
--     It's really pure checking for the "new" message count.
--     But it indicates when we have a new message.
local unread_count_last = nil
watch(
    os.getenv("HOME") .. "/bin/telegramstatus",
    1,
    function(_, stdout, _, _, exitcode)
        if exitcode ~= 0 then
            awesome.emit_signal(signal_name)
            return
        end

        local unread_count = tonumber(stdout:match('(%d+)'))

        if unread_count_last == nil or is_telegram_focused then
            unread_count_last = unread_count
        end

        local unread_count_diff = unread_count - unread_count_last

        awesome.emit_signal(signal_name, unread_count, unread_count_diff)

        unread_count_prev = unread_count
    end
)

client.connect_signal("focus", function(c)
    if not awful.rules.match(c, {class = "TelegramDesktop"}) then
        is_telegram_focused = false
        return
    end

    is_telegram_focused = true

    unread_count_last = unread_count_prev

    local unread_count_diff = 0

    awesome.emit_signal(signal_name, unread_count_prev, unread_count_diff)
end)

client.connect_signal("unfocus", function(c)
    is_telegram_focused = false
end)

return setmetatable(telegram, { __call = function(_, ...) return new(...) end })
