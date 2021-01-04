local awful = require("awful")
local watch = require("awful.widget.watch")

local signal_name_exists = "daemons::battery::exists"
local signal_name_status = "daemons::battery::status"

local function parse_upower_path(stdout)
    if type(stdout) ~= "string" then
       return "", false
    end

    local path = stdout:gsub("^%s*", ""):gsub("%s*$", "")
    if path == "" then
        return "", false
    end

    return path, true
end

local function parse_upower_info(stdout)
    if type(stdout) ~= "string" then
       return 0, false
    end

    local percentage = stdout:match("percentage:%s*(%d+)%%")
    if percentage == "" then
        return 0, false
    end

    return tonumber(percentage), true
end

-- TODO(SuperPaintman): replace it with DBus.
local exists = false
awful.spawn.easy_async(
    [[bash -c "upower -e | grep BAT | tail -1"]],
    function(stdout)
        local path, ok = parse_upower_path(stdout)
        if not ok then
            -- Emit only if the previous value was `true`.
            if exists then
                awesome.emit_signal(signal_name_exists, false, "")
            end

            exists = false

            return
        end

        awesome.emit_signal(signal_name_exists, true, path)

        exists = true
    end
)

local timer = nil
awesome.connect_signal(signal_name_exists, function(exists, path)
    if not exists then
        -- Stop timer if we launched it.
        if timer ~= nil then
            timer:stop()
            timer = nil
        end

        return
    end

    -- We already launched it.
    if timer ~= nil then
        return
    end

    _, timer = watch(
        [[bash -c "upower -i ]] .. path .. [["]],
        5,
        function(_, stdout)
            local percentage, ok = parse_upower_info(stdout)
            if not ok then
                return
            end

            awesome.emit_signal(signal_name_status, percentage)
        end
    )
end)

local mod = {
    signal_name_exists = signal_name_exists,
    signal_name_status = signal_name_status,
}

return mod
