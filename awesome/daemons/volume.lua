local watch = require("awful.widget.watch")

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

watch(
    [[amixer sget Master]],
    2,
    function(_, stdout)
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

local mod = {
    signal_name = signal_name,
}

return mod
