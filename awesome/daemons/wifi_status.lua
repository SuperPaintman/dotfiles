local watch = require("awful.widget.watch")

local signal_name = "daemons::wifi"

local status_connected = "connected"
local status_disconnected = "disconnected"
local status_error = "error"

local function parse_result(stdout, exitcode)
    if exitcode ~= 0 then
        return status_error, "", 0, true
    end

    if type(stdout) ~= "string" then
        return "", "", 0, false
    end

    local name, signal = stdout:match("connected%s+([^%s]+)%s+([0-9]+)")
    if signal == nil then
        if stdout:match("disconnected") then
            return status_disconnected, "", 0, true
        end

        return "", "", 0, false
    end

    return status_connected, name, tonumber(signal), true
end

watch(
    os.getenv("HOME") .. "/bin/wifistatus",
    10,
    function(_, stdout, _, _, exitcode)
        local status, name, signal, ok = parse_result(stdout, exitcode)
        if not ok then
            return
        end

        awesome.emit_signal(signal_name, status, name, signal)
    end
)

local mod = {
    signal_name = signal_name,
    status_connected = status_connected,
    status_disconnected = status_disconnected,
    status_error = status_error,
}

if _TEST then
    mod._private = {
        parse_result = parse_result,
    }
end

return mod
