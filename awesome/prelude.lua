--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")


-- Add vendor into the package path.
local cfgd = gears.filesystem.get_configuration_dir()

package.path = package.path
    .. ";" .. cfgd ..  "vendor/?/?.lua"
    .. ";" .. cfgd ..  "vendor/?/init.lua"
