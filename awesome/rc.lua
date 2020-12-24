-- See: https://awesomewm.org/doc/api/index.html.

--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi = require("beautiful.xresources").apply_dpi

local daemons = require("daemons")
local keys = require("keys")
local cpu_widget = require("widgets.cpu")
local ram_widget = require("widgets.ram")
local wifi_status_widget = require("widgets.wifi_status")
local vpn_status_widget = require("widgets.vpn_status")
local telegram_widget = require("widgets.telegram")
local battery_widget = require("widgets.battery")


--------------------------------------------------------------------------------
-- Error handling.
--------------------------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end


--------------------------------------------------------------------------------
-- Theme.
--------------------------------------------------------------------------------
beautiful.init(require("theme"))


--------------------------------------------------------------------------------
-- Layouts.
--------------------------------------------------------------------------------
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.magnifier
}

local default_layout = awful.layout.suit.tile


--------------------------------------------------------------------------------
-- Wallpaper.
--------------------------------------------------------------------------------
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

awful.screen.connect_for_each_screen(set_wallpaper)

-- Re-set wallpaper when a screen's geometry changes
-- (e.g. different resolution).
screen.connect_signal("property::geometry", set_wallpaper)


--------------------------------------------------------------------------------
-- Tags.
--------------------------------------------------------------------------------
local function set_tags(s)
    -- Each screen has its own tag table.
    local tagnames = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}

    awful.tag(tagnames, s, default_layout)
end

awful.screen.connect_for_each_screen(set_tags)


--------------------------------------------------------------------------------
-- Dashboard.
--------------------------------------------------------------------------------
-- TODO(SuperPaintman): add `z-index`-like thing.
-- TODO(SuperPaintman): hide it whet we have at least one window on the screen.
local function set_dashboard(s)
    local dashboard = wibox({
        screen = s,
        visible = true,
        ontop = false,
        type = "dock",
        -- input_passthrough = true,
        bg = "#00000000"
    })

    -- Visibility of dashboard widgets.
    local visible = true

    -- Widget: Clock.
    local clock = wibox.widget.textclock("%l:%M", 60)
    clock:set_align("center")
    clock:set_font("Helvetica Neue LT Std, sans medium 128")

    -- Widget: Date.
    local date = wibox.widget.textclock("%A, %e %B")
    date:set_align("center")
    date:set_font("Helvetica Neue LT Std, sans 32")

    local container = wibox.widget {
        nil,
        wibox.container.place(
            wibox.widget {
                clock,
                date,
                layout = wibox.layout.fixed.vertical
            }
        ),
        nil,
        layout = wibox.layout.align.horizontal
    }

    -- Widget: Eye button.
    local eye_button = wibox.widget.textbox("HIDE DASHBOARD")
    eye_button:set_font("sans bold 8")
    eye_button:set_opacity(0.5)
    eye_button:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                visible = not visible

                container.visible = visible

                if visible then
                    eye_button:set_text("HIDE DASHBOARD")
                else
                    eye_button:set_text("SHOW DASHBOARD")
                end
            end)
        )
    )
    eye_button:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = "hand1"
        end
    end)
    eye_button:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = "left_ptr"
        end
    end)

    local margin = dpi(16)

    -- Setup.
    dashboard:setup {
        container,
        wibox.container.place(
            wibox.container.margin(eye_button, margin, margin, margin, margin),
            "left",
            "bottom"
        ),
        layout = wibox.layout.stack
    }

    awful.placement.maximize(dashboard)
end

awful.screen.connect_for_each_screen(set_dashboard)


--------------------------------------------------------------------------------
-- Top bar.
--------------------------------------------------------------------------------
local function widget_margin(w, s)
    s = s or beautiful.wibar_widget_margin

    local wrapped = wibox.container.margin(w, s, s, s, s)

    -- Debug.
    -- wrapped = wibox.container.background(wrapped, "#FF0000")

    return wrapped
end

local function widget_margin_horizontal(w, s)
    s = s or beautiful.wibar_widget_margin

    local wrapped = wibox.container.margin(w, s, s)

    -- Debug.
    -- wrapped = wibox.container.background(wrapped, "#FF0000")

    return wrapped
end

local function set_top_bar(s)
    -- Initialize widgets.
    ---- Separator.
    local separator = wibox.widget.textbox("<span foreground='#FFFFFF3F'>|</span>")

    ---- Tagline.
    local taglist_buttons = gears.table.join(
        awful.button(
            {},
            1,
            function(t)
                t:view_only()
            end
        )
    )

    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    ---- Tasklist.
    local tasklist_buttons = gears.table.join(
        awful.button(
            {},
            1,
            function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end
        ),
        awful.button(
            {},
            3,
            function()
                awful.menu.client_list({theme = {width = 250}})
            end
        )
    )

    local tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    ---- Telegram.
    local telegram = telegram_widget()

    ---- CPU.
    local cpu = cpu_widget()

    ---- RAM.
    local ram = ram_widget()

    ---- Battery.
    local battery = battery_widget()

    ---- Wifi Status.
    local wifi_status = wifi_status_widget()

    ---- VPN Status.
    local vpn_status = vpn_status_widget()

    ---- Keyboard Layout.
    local keyboardlayout = awful.widget.keyboardlayout()

    ---- Systray.
    local systray = wibox.widget.systray()
    systray.set_base_size(beautiful.wibar_height - beautiful.wibar_widget_margin * 2)

    ---- Text Clock.
    local textclock = wibox.widget.textclock("%h %d  %I:%M:%S  %p", 1)

    ---- Layoutbox.
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
    )


    -- Create the Top Bar.
    local top_bar = awful.wibar {
        screen = s,
        position = beautiful.wibar_position or "top",
        width = beautiful.wibar_width,
        height = beautiful.wibar_height
    }

    -- Battery widget can work only on devices with battery.
    local optional_battery = widget_margin_horizontal(battery, dpi(6))
    optional_battery.visible = false

    -- TODO(SuperPaintman): refactor it.
    awesome.connect_signal(daemons.battery.signal_name_exists, function(exists)
        optional_battery.visible = exists
    end)

    -- Add widgets to the Top Bar.
    top_bar:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets.
            layout = wibox.layout.fixed.horizontal,
            taglist,
            widget_margin_horizontal(separator, dpi(12))
        },
        {
            -- Middle widgets.
            layout = wibox.layout.fixed.horizontal,
            widget_margin(tasklist)
        },
        {
            -- Right widgets.
            layout = wibox.layout.fixed.horizontal,
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin_horizontal(telegram, dpi(6)),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin_horizontal(cpu, dpi(6)),
            widget_margin_horizontal(ram, dpi(6)),
            optional_battery,
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin_horizontal(wifi_status, dpi(6)),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin_horizontal(vpn_status, dpi(6)),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin(keyboardlayout),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin(systray),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin(textclock),
            widget_margin_horizontal(separator, dpi(12)),
            widget_margin(layoutbox)
        }
    }
end

awful.screen.connect_for_each_screen(set_top_bar)


--------------------------------------------------------------------------------
-- Key bindings.
--------------------------------------------------------------------------------
root.keys(keys.global)


--------------------------------------------------------------------------------
-- Riles.
--------------------------------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.client,
            buttons = keys.client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {titlebars_enabled = true}
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}


--------------------------------------------------------------------------------
-- Signals.
--------------------------------------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c, {
            position = beautiful.titlebar_position or "top",
            size = beautiful.titlebar_size
        }):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Apply border color on an active client.
client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)

client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- Show titlebar only when window is floating.
local function should_show_client_titlebar(c)
    if c.maximized then
        return false
    end

    if c.floating then
        return true
    end

    -- On startup client does not have a "first_tab".
    if c.first_tag ~= nil and c.first_tag.layout == awful.layout.suit.floating then
        return true
    end

    return false
end

local function update_client_titlebar(c)
    if should_show_client_titlebar(c) then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end

client.connect_signal("property::maximized", update_client_titlebar)

client.connect_signal("property::floating", update_client_titlebar)

client.connect_signal("manage", update_client_titlebar)

tag.connect_signal("property::layout", function(t)
    for _, c in pairs(t:clients()) do
        update_client_titlebar(c)
    end
end)

-- Apply rounded corners on maximized clients.
if beautiful.client_radius ~= nil then
    local function update_client_shape(c)
        if c.maximized then
            c.shape = nil
        else
            c.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
            end
        end
    end

    client.connect_signal("property::maximized", update_client_shape)

    client.connect_signal("manage", update_client_shape)
end


--------------------------------------------------------------------------------
-- Host specific.
--------------------------------------------------------------------------------
if type(awesome.hostname) == "string" then
    local host_config_path = gears.filesystem.get_configuration_dir() .. "hosts/" .. awesome.hostname .. "/init.lua"

    if gears.filesystem.file_readable(host_config_path) then
        dofile(host_config_path)
    end
end
