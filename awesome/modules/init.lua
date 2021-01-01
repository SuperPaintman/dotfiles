--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local naughty = require("naughty")


--------------------------------------------------------------------------------
-- Modules.
--------------------------------------------------------------------------------
local modules = {
    "theme",
    "notifications"
}


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local function init()
    for _, module_name in ipairs(modules) do
        local _, err = pcall(function()
            require(string.format("modules.%s", module_name)).init()
        end)

        if err ~= nil then
            gears.debug.print_error(err)

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = string.format("modules: failed to init '%s' module", module_name),
                    text = err
                }
            )
        else
            gears.debug.print_warning(string.format("modules: '%s' was successfully loaded", module_name))
        end
    end
end


--------------------------------------------------------------------------------
-- Export.
--------------------------------------------------------------------------------
return {
    init = init,
}
