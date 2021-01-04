local awful = require("awful")

local signal_name = "daemons::volume"

local function parse_amixer(stdout)
    if type(stdout) ~= "string" then
        return false, 0, false
    end

    local volume, status =
        stdout:match('%[(%d?%d?%d)%%%]%s*%[(%a+)%]')
    if status == nil then
        return false, 0, false
    end

    local muted = false
    if status == "off" then
        muted = true
    end

    return muted, tonumber(volume) / 100, true
end

local function update()
    awful.spawn.easy_async(
        [[amixer sget Master]],
        function(stdout)
            local muted, volume, ok = parse_amixer(stdout)
            if not ok then
                return
            end

            -- Monitroid like.
            awesome.emit_signal(signal_name, {
              muted = muted,
              volume = volume,
            }, nil)
        end
    )
end

-- TODO(SuperPaintman): replace it with DBus or something else.
awful.spawn.with_line_callback(
    [[bash -c 'pactl subscribe | grep --line-buffered "sink"']],
    {
        stdout = function()
            update()
        end,
    }
)

update()

local mod = {
    signal_name = signal_name,
}

return mod
