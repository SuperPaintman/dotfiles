local watch = require("awful.widget.watch")

local signal_name = "daemons::ram"

local function parse_free(stdout)
    if type(stdout) ~= "string" then
        return 0, 0, false
    end

    local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
        stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
    if free_swap == nil then
        return 0, 0, false
    end

    return tonumber(total), tonumber(used), true
end

local function calculate_usage(total, used)
    local usage = used / total * 100

    return math.max(0, usage)
end

watch(
    'bash -c "free | grep -z Mem.*Swap.*"',
    1,
    function(_, stdout)
        local total, used, ok = parse_free(stdout)
        if not ok then
            return
        end

        local usage = calculate_usage(total, used)

        awesome.emit_signal(signal_name, usage)
    end
)

local mod = {
    signal_name = signal_name,
}

if _TEST then
    mod._private = {
        parse_free = parse_free,
        calculate_usage = calculate_usage,
    }
end

return mod
