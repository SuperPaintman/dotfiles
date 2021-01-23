local awful = require("awful")

local apps = {}

apps.appmenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/appmenu")
end

apps.windowmenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/windowmenu")
end

apps.vpnmenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/vpnmenu")
end

apps.powermenu = function()
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/powermenu")
end

apps.editor = function(key)
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/em")
end

apps.org = function(key)
    awful.spawn.with_shell(os.getenv("HOME") .. "/bin/org" .. " " .. key)
end

return apps
