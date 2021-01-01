--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")


--------------------------------------------------------------------------------
-- Helpers.
--------------------------------------------------------------------------------
local function escape_markup(v)
    local escape_pattern = "[<>&]"
    local escape_subs = { ['<'] = "&lt;", ['>'] = "&gt;", ['&'] = "&amp;" }

    return v:gsub(escape_pattern, escape_subs)
end

local function merge_options(args)
    local o = {}

    o.preset = gears.table.join(
        naughty.config.defaults or {},
        args.preset or naughty.config.presets.normal or {}
    )

    local preset = o.preset

    o.text = args.text or preset.text
    o.title = args.title or preset.title
    o.width = args.width or
        preset.width or
        beautiful.notification_width
    o.icon_size = args.icon_size or
        preset.icon_size or
        beautiful.notification_icon_size
    o.font = args.font or
        preset.font or
        beautiful.notification_font or
        beautiful.font or
        awesome.font
    o.fg = args.fg or
        preset.fg or
        beautiful.notification_fg or
        beautiful.fg_normal or
        "#ffffff"
    o.bg = args.bg or
        preset.bg or
        beautiful.notification_bg or
        beautiful.bg_normal or
        "#535d6c"
    o.margin = beautiful.notification_margin or 0
    o.actions = args.actions

    -- Custom.
    o.default_bg = beautiful.notification_bg or
        beautiful.bg_normal or
        "#535d6c"
    o.text_font = beautiful.notification_text_font or
        beautiful.notification_font or
        beautiful.font
    o.title_font = beautiful.notification_title_font or
        beautiful.notification_tfont or
        beautiful.font
    o.action_font = beautiful.notification_action_font or
        beautiful.notification_acfont or
        beautiful.font
    o.actions_width = beautiful.notification_actions_width
    o.title_margin = beautiful.notification_title_margin
    o.action_margin = beautiful.notification_action_margin
    o.action_border_size = beautiful.notification_action_border_size
    o.action_border_color = beautiful.notification_action_border_color

    return o
end

local function patch_notification(notification, args)
    -- Options.
    local o = merge_options(args)

    -- Containers.
    local iconbox = notification.iconbox
    local box = notification.box
    local textbox = notification.textbox

    -- Hooks.
    local die = notification.die

    local run = function ()
        if args.run then
            args.run(notification)
        else
            die(naughty.notificationClosedReason.dismissedByUser)
        end
    end

    -- Icon.
    local width_icon = 0
    local height_icon = 0

    local icon_layout = wibox.widget {
        layout = wibox.container.margin,
        right = o.margin,
        {
            layout = wibox.container.place,
            {
                -- widget = wibox.container.background,
                -- bg = "#FF0000",
                -- {
                widget = wibox.container.constraint,
                forced_width = o.icon_size,
                forced_height = o.icon_size,
                iconbox
                -- }
            }
        }
    }

    width_icon = o.icon_size + o.margin
    height_icon = o.icon_size

    if not iconbox then
        icon_layout.visible = false
        width_icon = 0
        height_icon = 0
    end

    -- Actions.
    local width_actions = 0
    local height_actions = 0

    local actions_container = nil

    if o.actions then
        actions_container = wibox.layout.fixed.vertical()

        local len = 0
        for _ in pairs(o.actions) do
            len = len + 1
        end

        local i = 0
        for action, callback in pairs(o.actions) do
            local is_first = i == 0
            local is_last = i == len - 1

            local action_textbox = wibox.widget {
                widget = wibox.widget.textbox,
                text = action,
                font = o.action_font,
                valign = "middle",
                align = "center"
            }
            action_textbox:buttons(
                gears.table.join(
                    awful.button({}, 1, callback),
                    awful.button({}, 3, callback)
                )
            )

            local border_bottom = o.action_border_size
            local margin_top = o.action_margin
            local margin_bottom = o.action_margin

            if is_first then
                margin_top = 0
            end

            if is_last then
                border_bottom = 0
                margin_bottom = 0
            end

            local action_layout = wibox.widget {
                layout = wibox.container.margin,
                bottom = border_bottom,
                color = o.action_border_color,
                {
                    layout = wibox.container.margin,
                    top = margin_top,
                    bottom = margin_bottom,
                    left = o.action_margin,
                    right = o.action_margin,
                    action_textbox
                }
            }

            actions_container:add(action_layout)

            local height_action = action_textbox:get_height_for_width(o.actions_width - o.action_margin * 2, notification.screen)
            height_actions = height_actions + height_action + border_bottom + margin_top + margin_bottom

            i = i + 1
        end
    end

    local actions_layout = wibox.widget {
        layout = wibox.container.margin,
        left = o.margin,
        {
            layout = wibox.container.margin,
            left = o.action_border_size,
            color = o.action_border_color,
            {
                layout = wibox.container.place,
                {
                    -- widget = wibox.container.background,
                    -- bg = "#0000FF",
                    -- {
                    widget = wibox.container.constraint,
                    forced_width = o.actions_width,
                    actions_container
                    -- }
                }
            }
        }
    }

    width_actions = o.actions_width + o.margin + o.action_border_size

    if not actions_container then
        actions_layout.visible = false
        width_actions = 0
        height_actions = 0
    end

    -- Content.
    local width_content = o.width - width_icon - width_actions - o.margin * 2
    local height_content = 0

    local titlebox = wibox.widget {
        widget = wibox.widget.textbox,
        text = o.title,
        font = o.title_font,
        valign = "middle"
    }

    local title_layout = wibox.widget {
        layout = wibox.container.margin,
        bottom = o.title_margin,
        titlebox
    }

    textbox:set_font(o.text_font)
    textbox:set_text(o.text)

    if o.text == "" then
        title_layout.bottom = 0
    end

    local content_layout = wibox.widget {
        -- widget = wibox.container.background,
        -- bg = "#0000FF",
        -- {
        layout = wibox.container.place,
        halign = "left",
        {
            layout = wibox.layout.fixed.vertical,
            title_layout,
            textbox
        }
        -- }
    }

    local height_title = titlebox:get_height_for_width(width_content, notification.screen)
    local height_text = textbox:get_height_for_width(width_content, notification.screen)

    height_content = height_title + height_text

    if o.title ~= "" and o.text ~= "" then
        height_content = height_content + o.title_margin
    end

    -- Main.
    local main_layout = wibox.widget {
        layout = wibox.layout.align.horizontal,
        -- Icon.
        icon_layout,
        -- Content.
        content_layout,
        -- Actions.
        actions_layout,
    }

    -- Patch.
    box.bg = o.default_bg

    box:set_widget(
        wibox.container.margin(main_layout, o.margin, o.margin, o.margin, o.margin)
    )

    -- TODO(SuperPaintman): replace with different layout.
    icon_layout:buttons(
        gears.table.join(
            awful.button({}, 1, nil, run),
            awful.button({}, 3, nil, function()
                die(naughty.notificationClosedReason.dismissedByUser)
            end)
        )
    )
    content_layout:buttons(
        gears.table.join(
            awful.button({}, 1, nil, run),
            awful.button({}, 3, nil, function()
                die(naughty.notificationClosedReason.dismissedByUser)
            end)
        )
    )

    -- Calculate total height and set it.
    local default_height = 32

    local h = math.max(default_height, height_icon, height_content, height_actions)

    -- Add margin to the height.
    h = h + o.margin * 2

    -- Set default value if something went wrong.
    h = math.max(h, default_height)

    notification.height = h
    box:geometry {
        height = notification.height
    }
end

-- Decorate original naughty.notify to modify notification style.
--
-- This is a quite dirty implantation. It might break one day.
--
-- See: $(nix eval --raw nixos.awesome.outPath)/share/awesome/lib/naughty/core.lua
local function wrap_notify(notify)
    return function(args)
        local notification = notify(args)

        patch_notification(notification, args)

        return notification
    end
end


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local function init()
    -- Save original function.
    if naughty._notify == nil then
        naughty._notify = naughty.notify
    end

    naughty.notify = wrap_notify(naughty._notify)
end


--------------------------------------------------------------------------------
-- Export.
--------------------------------------------------------------------------------
return {
    init = init,
}
