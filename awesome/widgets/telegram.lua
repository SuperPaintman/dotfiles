local awful = require("awful")
local gears = require("gears")
local wibox = require('wibox')
local margin = require("wibox.container.margin")
local textbox = require("wibox.widget.textbox")
local watch = require("awful.widget.watch")

local colors = require("colors")
local icon = require("widgets.icon")
local underline = require("widgets.underline")


local signal_name = "widgets::telegram"

local telegram = {}

local function new()
    local color = colors.normal.blue
    local color_diff = colors.normal.green
    local color_error = colors.normal.red

    local textbox_widget = textbox("")
    local icon_widget = icon {
        name = "telegram",
        color = colors.normal.blue
    }
    local content_widget = wibox.widget{
        margin(icon_widget, 2, 2, 2, 2),
        margin(textbox_widget, 4, 0, 0, 0),
        widget = wibox.layout.fixed.horizontal
    }
    local widget = underline(content_widget, color)

    local function handler(unread_count, unread_count_diff)
        local markup = ""

        if unread_count_diff == nil then
            markup = string.format("<span foreground='%s'>error</span>", color_error)
        elseif unread_count_diff > 0 then
            markup = string.format("%d (<span foreground='%s'>+%d</span>)", unread_count, color_diff, unread_count_diff)
        else
            markup = string.format("%d", unread_count)
        end

        textbox_widget:set_markup(markup)
    end

    handler(0, 0)

    widget:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                local matcher = function (c)
                    return awful.rules.match(c, {class = "TelegramDesktop"})
                end

                local found = false

                for c in awful.client.iterate(matcher) do
                    found = true

                    c:jump_to()

                    break
                end

                if not found then
                    awful.spawn("telegram-desktop")
                end
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
