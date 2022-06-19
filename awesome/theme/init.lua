--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local naughty = require("naughty")
local dpi = require("beautiful.xresources").apply_dpi
local theme_assets = require("beautiful.theme_assets")
local wibox = require("wibox")
local tag = require("awful.tag")

local colors = require("colors")


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local theme = {}

local base_theme_name = "default"

local base_theme_path = gears.filesystem.get_themes_dir() .. base_theme_name .. "/theme.lua"

if gears.filesystem.file_readable(base_theme_path) then
    local base_theme = dofile(base_theme_path)

    theme = gears.table.clone(base_theme)
else
    local err = string.format("theme: failed to find '%s' base theme", base_theme_name)

    gears.debug.print_error(err)
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = err,
        }
    )
end

local theme_dir = gears.filesystem.get_configuration_dir() .. "theme"

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
theme.fg_normal = colors.primary.foreground
theme.bg_normal = colors.primary.background -- .. "98"
theme.fg_focus = colors.normal.yellow
theme.bg_focus = colors.bright.black
theme.fg_urgent = theme.fg_normal
theme.bg_urgent = colors.normal.red


--------------------------------------------------------------------------------
-- Clients.
--------------------------------------------------------------------------------
theme.client_radius = dpi(4)


--------------------------------------------------------------------------------
-- Borders.
--------------------------------------------------------------------------------
theme.border_width = dpi(1)
theme.border_normal = colors.normal.black
theme.border_focus = color_border


--------------------------------------------------------------------------------
-- Useless gap.
--------------------------------------------------------------------------------
theme.useless_gap = dpi(2)


--------------------------------------------------------------------------------
-- Titlebars.
--------------------------------------------------------------------------------
theme.titlebar_size = dpi(22)
theme.titlebar_fg_normal = colors.primary.foreground
-- theme.titlebar_bg_normal = colors.normal.background -- "00"


--------------------------------------------------------------------------------
-- Wibars.
--------------------------------------------------------------------------------
theme.wibar_height = dpi(22)
theme.wibar_widget_margin = dpi(2)
if colors.awesome ~= nil and colors.awesome.wibar ~= nil then
    theme.wibar_bg = colors.awesome.wibar.background
end


--------------------------------------------------------------------------------
-- Taglist.
--------------------------------------------------------------------------------
theme.taglist_font = "sans bold 10"

theme.taglist_bg_focus = "#00000000"
theme.taglist_fg_focus = colors.normal.yellow
theme.taglist_underline_focus = colors.normal.yellow

theme.taglist_bg_urgent = theme.taglist_bg_focus
theme.taglist_fg_urgent = colors.normal.red
theme.taglist_underline_urgent = colors.normal.red

theme.taglist_bg_occupied = theme.taglist_bg_focus
theme.taglist_fg_occupied = colors.primary.foreground
theme.taglist_underline_occupied = colors.primary.foreground

theme.taglist_bg_empty = theme.taglist_bg_focus
theme.taglist_fg_empty = colors.bright.black

theme.taglist_bg_volatile = theme.taglist_bg_focus
theme.taglist_fg_volatile = colors.primary.foreground


local function update_tasklist_widget(self, t)
    local underline_role = self:get_children_by_id("underline_role")[1]

    local urgent = tag.getproperty(t, "urgent")
    local occupied = #t:clients() > 0

    if underline_role ~= nil then
        if t.selected then
            underline_role.color = theme.taglist_underline_focus
        elseif urgent then
            underline_role.color = theme.taglist_underline_urgent
        elseif occupied then
            underline_role.color = theme.taglist_underline_occupied
        else
            underline_role.color = nil
        end
    end
end

local tasklist_widget_margin = dpi(2)
theme.tasklist_widget_template = {
    layout = wibox.container.margin,
    top = tasklist_widget_margin,
    {
        id = "underline_role",
        layout = wibox.container.margin,
        bottom = tasklist_widget_margin,
        -- color = "#000000",
        {
            id     = "background_role",
            widget = wibox.container.background,
            {
                layout = wibox.container.place,
                forced_width = theme.titlebar_size,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        id     = "index_role",
                        widget = wibox.widget.textbox,
                    },
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                },
            },
        },
    },
    create_callback = function(self, t, index, objects)
        update_tasklist_widget(self, t)
    end,
    update_callback = function(self, t, index, objects)
        update_tasklist_widget(self, t)
    end,
}

theme.taglist_spacing = tasklist_widget_margin * 2

theme.taglist_shape = nil
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil


--------------------------------------------------------------------------------
-- Tasklist.
--------------------------------------------------------------------------------
theme.tasklist_disable_task_name = true


--------------------------------------------------------------------------------
-- Systray.
--------------------------------------------------------------------------------
theme.bg_systray = colors.primary.background
theme.systray_icon_spacing = theme.wibar_widget_margin


--------------------------------------------------------------------------------
-- Notification.
--------------------------------------------------------------------------------
theme.notification_bg = colors.primary.background -- .. "DE"
-- theme.notification_bg = "#FF00FF" -- .. "DE"
theme.notification_border_width = 0
theme.notification_width = dpi(320)
theme.notification_actions_width = dpi(72)
theme.notification_max_width = theme.notification_width
theme.notification_shape = function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, dpi(4))
end
theme.notification_margin = dpi(10)
theme.notification_title_margin = dpi(4)
theme.notification_action_margin = dpi(8)
theme.notification_action_border_size = dpi(1)
theme.notification_action_border_color = "#FFFFFF22"
theme.notification_icon_size = dpi(32)
theme.notification_font = theme.font
theme.notification_text_font = theme.notification_font
theme.notification_title_font = "sans bold 12"
theme.notification_action_font = "sans bold 10"


--------------------------------------------------------------------------------
-- Widget.
--------------------------------------------------------------------------------
theme.widget_color = colors.primary.foreground
if colors.awesome ~= nil and colors.awesome.widgets ~= nil then
    -- Battery.
    theme.widget_battery_color = colors.awesome.widgets.battery and colors.awesome.widgets.battery.normal

    -- Brightness.
    theme.widget_brightness_color = colors.awesome.widgets.brightness and colors.awesome.widgets.brightness.normal

    -- CPU.
    theme.widget_cpu_color = colors.awesome.widgets.cpu and colors.awesome.widgets.cpu.normal

    -- Disk.
    theme.widget_disk_color = colors.awesome.widgets.disk and colors.awesome.widgets.disk.normal

    -- RAM.
    theme.widget_ram_color = colors.awesome.widgets.ram and colors.awesome.widgets.ram.normal

    -- Volume.
    theme.widget_volume_color = colors.awesome.widgets.volume and colors.awesome.widgets.volume.normal
    theme.widget_volume_muted_color = colors.awesome.widgets.volume and colors.awesome.widgets.volume.muted
end

return theme
