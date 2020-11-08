-- <awesomewm>/share/awesome/lib/awful.lua
local awful = {
    widget = {
        watch = require("mocks.awful.widget.watch")
    }
}

package.preload["awful"] = function()
    return awful
end
