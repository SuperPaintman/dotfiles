--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____ = "use strict"
local watch = require("awful.widget.watch")
____exports.signal_name = "daemons::wifi"
____exports.status_connected = "connected"
____exports.status_disconnected = "disconnected"
____exports.status_error = "error"
local home = os.getenv("HOME") or "~"
local function parse_result(stdout, exitcode)
    if exitcode ~= 0 then
        return ____exports.status_error, "", 0, true
    end
    if type(stdout) ~= "string" then
        return "", "", 0, false
    end
    local name, signal = stdout:match("connected%s+([^%s]+)%s+([0-9]+)")
    if signal == nil then
        local v = stdout:match("disconnected")
        if v then
            return ____exports.status_disconnected, "", 0, true
        end
        return "", "", 0, false
    end
    return ____exports.status_connected, name, tonumber(signal) or 0, true
end
watch(
    tostring(home) .. "/bin/wifistatus",
    10,
    function(_w, stdout, _stderr, _r, exitcode)
        local status, name, signal, ok = parse_result(stdout, exitcode)
        if not ok then
            return
        end
        awesome.emit_signal(____exports.signal_name, status, name, signal)
    end
)
____exports._private = {parse_result = parse_result}
return ____exports
