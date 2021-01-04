local watch = require("awful.widget.watch")

local signal_name = "daemons::brightness"

local function parse_brightness(stdout)
    if type(stdout) ~= "string" then
        return 0, false
    end

    local level = stdout:match(',(%d?%d?%d)%%,')
    if level == nil then
        return 0, false
    end

    return tonumber(level) / 100, true
end

-- TODO(SuperPaintman): replace it with DBus.
watch(
    [[brightnessctl info --machine-readable]],
    2,
    function(_, stdout)
        local level, ok = parse_brightness(stdout)
        if not ok then
            return
        end

        -- Monitroid like.
        awesome.emit_signal(signal_name, {
          level = level,
        }, nil)
    end
)

local mod = {
    signal_name = signal_name,
}

return mod
