--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local watch = require("awful.widget.watch")
local json = require("json")


--------------------------------------------------------------------------------
-- Constants.
--------------------------------------------------------------------------------
local signals = {
    cpu = "daemons::monitroid::cpu",
    ram = "daemons::monitroid::ram",
    disk = "daemons::monitroid::disk",
}


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local prev = {}
local function is_changed(stats, name)
    if stats.gatherers == nil then
        return false
    end

    if stats.gatherers[name] == nil then
        return false
    end

    if prev.gatherers == nil then
        return true
    end

    if prev.gatherers[name] == nil then
        return true
    end

    return prev.gatherers[name].generation ~= stats.gatherers[name].generation
end

local function update(stats, name)
    if not is_changed(stats, name) then
        return
    end

    awesome.emit_signal(signals[name], stats.gatherers[name].success, stats.gatherers[name].error)
end

local function handle(_, stdout, _, _, exitcode)
    if exitcode ~= 0 then
        return
    end

    local stats = json.decode(stdout)
    if stats.gatherers == nil then
        return
    end

    update(stats, "cpu")
    update(stats, "ram")
    update(stats, "disk")

    prev = stats
end

local steps = {
    function(next_step)
        awful.spawn.easy_async(
            [[which monitroidctl]],
            function(_, _, _, exitcode)
                if exitcode ~= 0 then
                    gears.debug.print_error("daemons: monitroidctl not found")
                    return
                end

                next_step()
            end
        )
    end,
    function(next_step)
        awful.spawn.easy_async(
            [[monitroidctl]],
            function(_, stderr, _, exitcode)
                if exitcode ~= 0 then
                    gears.debug.print_error(string.format("daemons: failed to call monitroidctl: %s", stderr))
                    return
                end

                next_step()
            end
        )
    end,
    function(next_step)
        watch(
            [[monitroidctl]],
            1,
            handle
        )
    end,
}

local i = 1
local function next_step()
    if i > #steps then
        return
    end

    local step = steps[i]
    i = i + 1

    step(next_step)
end

next_step()


--------------------------------------------------------------------------------
-- Export.
--------------------------------------------------------------------------------
local mod = {
    signals = signals,
}

return mod
