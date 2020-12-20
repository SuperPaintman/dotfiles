--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local icons_dir = gears.filesystem.get_configuration_dir() .. "icons/assets"

local assets = {
    "cpu",
    "ram",
    "shield-hollow",
    "shield",
    "telegram",
}

local icons = {}

for _, v in ipairs(assets) do
    local path = icons_dir .. "/" .. v .. ".svg"
    if gears.filesystem.file_readable(path) then
        icons[v] = path
    end
end


return icons
