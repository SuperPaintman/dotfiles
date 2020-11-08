-- <awesomewm>/share/awesome/lib/awful/widget/watch.lua
local watches = {}

local watch = { mt = {} }

function watch.new(command, timeout, callback, base_widget)
    table.insert(watches, {
        command = command,
        timeout = timeout,
        callback = callback,
        base_widget = base_widget,
    })

    -- TODO
    return nil, nil
end

function watch.mt.__call(_, ...)
    return watch.new(...)
end

local watch_module = setmetatable(watch, watch.mt)

package.preload["awful.widget.watch"] = function()
    return watch_module
end

return {
    watches = watches,
}
