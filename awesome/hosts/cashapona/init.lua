local awful = require("awful")

-- Setup displays.
awful.spawn("xrandr --output eDP-1 --primary --pos 0x1080 --output DP-3 --pos 0x0", {})
