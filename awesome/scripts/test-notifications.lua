--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
require("prelude")
local naughty = require("naughty")
local beautiful = require("beautiful")


--------------------------------------------------------------------------------
-- Test.
--------------------------------------------------------------------------------
package.loaded["theme"] = nil
package.loaded["modules.notifications"] = nil

beautiful.init(require("theme"))
require("modules.notifications").init()


naughty.destroy_all_notifications()

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with text",
        text = "Small text",
        timeout = 0,
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification without text",
        timeout = 0,
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with icon",
        icon = "/home/superpaintman/Downloads/8445785.jpg",
        timeout = 0,
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with icon and text",
        text = "This is my text",
        icon = "/home/superpaintman/Downloads/8445785.jpg",
        timeout = 0,
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with icon and long text",
        text = "This is a very long text. This is a very long text. This is a very long text. This is a very long text. This is a very long text.",
        icon = "/home/superpaintman/Downloads/8445785.jpg",
        timeout = 0,
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with actions",
        timeout = 0,
        actions = {
            ["Close"] = function () end
        },
    }
)

naughty.notify(
    {
        preset = naughty.config.presets.normal,
        title = "Notification with actions (2 buttons)",
        timeout = 0,
        actions = {
            ["OK"] = function () end,
            ["Cancel"] = function () end
        },
    }
)
