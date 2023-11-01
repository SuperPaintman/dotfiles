-- See: https://lodash.com/docs/4.17.15
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------
---@generic T: fun(...): nil
---@param f T
---@param wait number?
---@return T, (fun(): nil)
M.debounce = function(f, wait)
  wait = wait or 0

  local running = false
  local timer = vim.loop.new_timer()
  local wrapper = function(...)
    if running then
      return
    end
    running = true

    local argv = { ... }
    timer:start(wait, 0, function()
      timer:stop()
      vim.schedule_wrap(f)(unpack(argv))
      running = false
    end)
  end

  local cancel = function()
    timer:stop()
  end

  return wrapper, cancel
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
