--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local colors = require("colors")


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local base_theme_name = "zenburn"

local base_theme = dofile(gears.filesystem.get_themes_dir() .. base_theme_name .. "/theme.lua")

local theme_dir = gears.filesystem.get_configuration_dir() .. "theme"

-- local theme = {}
local theme = gears.table.clone(base_theme)

local color_border = colors.normal.blue -- TODO(SuperPaintman): move it into `config.yml`. It's also used in rofi.


--------------------------------------------------------------------------------
-- Font.
--------------------------------------------------------------------------------
theme.font = "sans 10"


--------------------------------------------------------------------------------
-- Wallpaper.
--------------------------------------------------------------------------------
local wallpaper_path = os.getenv("HOME") .. "/.wallpaper"

if gears.filesystem.file_readable(wallpaper_path) then
    theme.wallpaper = wallpaper_path
end


--------------------------------------------------------------------------------
-- Colors.
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Borders.
--------------------------------------------------------------------------------
theme.border_width = dpi(1)
theme.border_focus  = color_border


--------------------------------------------------------------------------------
-- Titlebars.
--------------------------------------------------------------------------------
theme.titlebar_size = dpi(20)


--------------------------------------------------------------------------------
-- Wibars.
--------------------------------------------------------------------------------
theme.wibar_height = dpi(20)


return theme
