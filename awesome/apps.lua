local awful = require("awful")

local apps = {}

apps.appmenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/appmenu")
end

apps.windowmenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/windowmenu")
end

return apps
