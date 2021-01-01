--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")
local json = require("json")


--------------------------------------------------------------------------------
-- Init.
--------------------------------------------------------------------------------
local state_path = gears.filesystem.get_cache_dir() .. "state.json"


--------------------------------------------------------------------------------
-- Helpers.
--------------------------------------------------------------------------------
local function find_layout(name)
    for _, l in ipairs(awful.layout.layouts) do
        if l.name == name then
            return l
        end
    end

    return nil
end

local function write_file(path, data)
    local file = io.open(path, "w")
    file:write(data)
    file:close()
end

local function read_file(path)
    local file = io.open(path, "r")
    local data = file:read("*all")
    file:close()
    return data
end


--------------------------------------------------------------------------------
-- Functions.
--------------------------------------------------------------------------------
local function store()
    -- mkdir the parent directory.
    local ok, err = gears.filesystem.make_parent_directories(state_path)
    if err ~= nil then
        return false, err
    end

    -- Gather current state.
    local state = {
        version = "1",
        screens = {},
    }

    for s in screen do
        state.screens[tostring(s.index)] = {
            index = s.index,
            tags = {},
        }

        local sd = state.screens[tostring(s.index)]

        for _, t in ipairs(s.tags) do
            local td = {
                index = t.index,
                selected = t.selected,
                master_width_factor = t.master_width_factor,
                layout = t.layout.name,
            }

            sd.tags[tostring(t.index)] = td
        end
    end

    -- Encode the state.
    local dump = json.encode(state)

    -- Write dump into the file.
    write_file(state_path, dump)

    return true, nil
end

local function restore()
    -- Check if the state file exists.
    if not gears.filesystem.file_readable(state_path) then
        return false, nil
    end

    -- Read the state file.
    local dump = read_file(state_path)

    -- Decode the state file.
    local state = json.decode(dump)

    -- Restore the state.
    if state.version ~= "1" then
        return false, string.format("bad version: %d", state.version)
    end

    for _, s in pairs(state.screens) do
        local sr = screen[s.index]

        if sr ~= nil then
            -- Restore screen.
            for _, t in pairs(s.tags) do
                local tr = sr.tags[t.index]

                if tr ~= nil then
                    -- Restore tag.
                    tr.selected = t.selected
                    tr.master_width_factor = t.master_width_factor

                    local layout = find_layout(t.layout)
                    if layout ~= nil then
                        tr.layout = layout
                    end
                end
            end
        end
    end

    return true, nil
end

local function remove()
    -- Check if the state file exists.
    if not gears.filesystem.file_readable(state_path) then
        return false, nil
    end

    -- Remove the state file.
    os.remove(state_path)

    return true, nil
end


--------------------------------------------------------------------------------
-- Export.
--------------------------------------------------------------------------------
return {
    store = store,
    restore = restore,
    remove = remove,
}
