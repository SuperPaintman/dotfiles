--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local apps = require("apps")


--------------------------------------------------------------------------------
-- Mod keys.
--------------------------------------------------------------------------------
local modkey = "Mod4" -- aka Super / Win.
local altkey = "Mod1"
local ctrlkey = "Control"
local shiftkey = "Shift"


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local keys = {}

keys.modkey = modkey

local terminal = "alacritty" -- TODO(SuperPaintman): move it into the config.


--------------------------------------------------------------------------------
-- Global keys.
--------------------------------------------------------------------------------
keys.global = {}

keys.global =
    gears.table.join(
    keys.global,
    awful.key(
        {modkey},
        "s",
        hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}
    ),
    awful.key(
        {modkey},
        "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),
    awful.key(
        {modkey},
        "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),
    awful.key(
        {modkey},
        "Escape",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}
    ),
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "w",
        apps.windowmenu,
        {description = "show window menu", group = "launcher"}
    ),
    -- Layout manipulation
    awful.key(
        {modkey, shiftkey},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, shiftkey},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key(
        {modkey},
        "u",
        awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}
    ),
    awful.key(
        {modkey},
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    -- Standard program
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),
    awful.key(
        {modkey, shiftkey},
        "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),
    awful.key(
        {modkey},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {modkey, shiftkey},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, shiftkey},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey},
        "space",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next", group = "layout"}
    ),
    awful.key(
        {modkey, shiftkey},
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- Prompt
    awful.key(
        {modkey},
        "r",
        apps.appmenu,
        {description = "show app menu", group = "launcher"}
    ),
    awful.key(
        {modkey},
        "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),

    -- Focus on applications.
    ---- Browser
    awful.key(
        {modkey, altkey},
        "b",
        function()
            local matcher = function (c)
                return awful.rules.match(c, {class = "Firefox"})
            end

            for c in awful.client.iterate(matcher) do
                c:jump_to()

                return
            end
        end
    ),

    ---- Editor
    awful.key(
        {modkey, altkey},
        "e",
        function()
            local screen = awful.screen.focused()

            local matcher = function (c)
                return awful.rules.match(c, {
                    class = "Code",
                    -- screen = screen,
                })
            end

            for c in awful.client.iterate(matcher) do
                c:jump_to()

                return
            end
        end
    ),

    ---- Telegram
    awful.key(
        {modkey, altkey},
        "t",
        function()
            local matcher = function (c)
                return awful.rules.match(c, {class = "TelegramDesktop"})
            end

            for c in awful.client.iterate(matcher) do
                c:jump_to()

                return
            end

            awful.spawn("telegram-desktop")
        end
    ),

    ---- Terminal
    awful.key(
        {modkey, altkey},
        "Return",
        function()
            local matcher = function (c)
                return awful.rules.match(c, {class = "Alacritty"})
            end

            for c in awful.client.iterate(matcher) do
                c:jump_to()

                return
            end
        end
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.global =
        gears.table.join(
        keys.global,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, ctrlkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag.
        awful.key(
            {modkey, shiftkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, ctrlkey, shiftkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end


--------------------------------------------------------------------------------
-- Client keys.
--------------------------------------------------------------------------------
keys.client = {}

keys.client =
    gears.table.join(
    keys.client,
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey, shiftkey},
        "c",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key(
        {modkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),
    awful.key(
        {modkey},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}
    ),
    awful.key(
        {modkey, ctrlkey},
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key(
        {modkey, shiftkey},
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"}
    )
)


--------------------------------------------------------------------------------
-- Client buttons.
--------------------------------------------------------------------------------
keys.client_buttons = {}

keys.client_buttons =
    gears.table.join(
    keys.client_buttons,
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)


return keys
