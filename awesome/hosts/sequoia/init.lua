local awful = require("awful")

-- Setup displays.
awful.spawn("xrandr --output DVI-D-0 --left-of DVI-I-1", {})
