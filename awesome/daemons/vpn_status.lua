local watch = require("awful.widget.watch")

local signal_name = "daemons::vpn"

local status_connected = "connected"
local status_connecting = "connecting"
local status_disconnected = "disconnected"
local status_error = "error"

local function parse_result(stdout, exitcode)
    if exitcode ~= 0 then
        return status_error, "", "", true
    end

    if type(stdout) ~= "string" then
        return "", "", "", false
    end

    local status, name, ip = stdout:match('(%w+)%s+([^%s]+)%s+([0-9\\.]+)')
    if status == nil then
        if stdout:match("disconnected") then
            return status_disconnected, "", "", true
        end

        return "", "", "", false
    end

    if status == "connected" then
        return status_connected, name, ip, true
    end

    if status == "connecting" then
        return status_connecting, name, ip, true
    end

    return status_error, "", "", true
end

watch(
    os.getenv("HOME") .. "/bin/vpnstatus",
    1,
    function(_, stdout, _, _, exitcode)
        local status, name, ip, ok = parse_result(stdout, exitcode)
        if not ok then
            return
        end

        awesome.emit_signal(signal_name, status, name, ip)
    end
)

local mod = {
    signal_name = signal_name,
    status_connected = status_connected,
    status_connecting = status_connecting,
    status_disconnected = status_disconnected,
    status_error = status_error,
}

if _TEST then
    mod._private = {
        parse_result = parse_result,
    }
end

return mod
