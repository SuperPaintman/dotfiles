--------------------------------------------------------------------------------
-- Imports.
--------------------------------------------------------------------------------
local gears = require("gears")

local cfgd = gears.filesystem.get_configuration_dir()

local lib
local _, err = pcall(function()
  local ffi = require("ffi")
  lib = ffi.load(cfgd .. "/awesomex/target/release/libawesomex.so")
  ffi.cdef[[
    int awesomex_start(void);
    int awesomex_stop(void);
  ]]
end)

if err ~= nil then
  gears.debug.print_error(string.format("awesomex: failed to load libawesomex.so: %s", err))
  gears.debug.print_error(string.format("awesomex: try to run and then restart the WM:\n\n\t(cd %sawesomex && cargo build --release)\n", gears.filesystem.get_configuration_dir()))
  return
end

local function start()
  gears.debug.print_warning("awesomex: start the work thread")
  local res = lib.awesomex_start()
  if res ~= 0 then
    gears.debug.print_error(string.format("awesomex: awesomex_start() returned error status code: %d", res))
    return
  end
  gears.debug.print_warning("awesomex: the work thread has started")
end

local function stop()
  gears.debug.print_warning("awesomex: stop the work thread")
  local res = lib.awesomex_stop()
  if res ~= 0 then
    gears.debug.print_error(string.format("awesomex: awesomex_stop() returned error status code: %d", res))
    return
  end
  gears.debug.print_warning("awesomex: the work thread has stopped")
end

-- Run the work thread.
awesome.connect_signal("exit", function()
  stop()
end)

start()

return
