local watch = require("awful.widget.watch")

local signal_name = "daemons::cpu"

local function parse_proc_cpu_stat(stdout)
    if type(stdout) ~= "string" then
        return 0, 0, false
    end

    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')
    if guest_nice == nil then
        return 0, 0, false
    end

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    return total, tonumber(idle), true
end

local function calculate_usage(prev_total, prev_idle, total, idle)
    local diff_total = total - prev_total
    local diff_idle = idle - prev_idle

    local usage = (diff_total - diff_idle) / diff_total * 100

    return math.max(0, usage)
end

local prev_total = 0
local prev_idle = 0
watch(
    [[bash -c "cat /proc/stat | grep '^cpu '"]],
    3,
    function(_, stdout)
        local total, idle, ok = parse_proc_cpu_stat(stdout)
        if not ok then
            return
        end

        local usage = calculate_usage(prev_total, prev_idle, total, idle)

        awesome.emit_signal(signal_name, usage)

        prev_total = total
        prev_idle = idle
    end
)

local mod = {
    signal_name = signal_name,
}

if _TEST then
    mod._private = {
        parse_proc_cpu_stat = parse_proc_cpu_stat,
        calculate_usage = calculate_usage,
    }
end

return mod
