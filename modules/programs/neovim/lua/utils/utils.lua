---@see https://lodash.com/docs/4.17.15

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------

local vim = _G.vim or {}
local uv = vim.uv or vim.loop

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local M = {}

--------------------------------------------------------------------------------
-- Table
--------------------------------------------------------------------------------

---@generic T1
---@generic T2
---@param left T1[]
---@param right T2[]
---@return (T1 | T2)[]
M.concat = function(left, right)
  local res = {}

  for _, item in ipairs(left) do
    table.insert(res, item)
  end

  for _, item in ipairs(right) do
    table.insert(res, item)
  end

  return res
end

---@generic T
---@param tbl T[]
---@return T[]
M.uniq = function(tbl)
  local res = {}
  local seen = {}

  for _, item in ipairs(tbl) do
    if not seen[item] then
      seen[item] = true
      table.insert(res, item)
    end
  end

  return res
end

--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------

--- Binds `self` as the first argument to `f`.
---@generic T : fun(): ...
---@param f T
---@param self any
---@return T
M.bind = function(f, self)
  local bound = function(...) return f(self, ...) end
  return bound
end

--- Returns a function that invokes f only once and returns the value returned
--- by f.
---@generic T : fun(): ...
---@param f T
---@return T
M.once = function(f)
  local initialized = false
  local valid = false
  local results = nil ---@type any[]

  local wrapper = function()
    if not initialized then
      initialized = true
      results = { pcall(f) }
      valid = results[1]
    end

    if not valid then
      error(results[2])
    end

    return unpack(results, 2)
  end

  return wrapper
end

---@generic T : fun(...): ...
---@param f T
---@param wait number?
---@return T -- debounced function
---@return (fun(): nil) -- cancel
M.debounce = function(f, wait)
  wait = wait or 0

  local running = false
  local last_args = {}
  local timer = nil
  local wrapper = function(...)
    if timer == nil then
      timer = uv.new_timer()
    end

    last_args = { ... }

    if running then
      return
    end
    running = true

    timer:start(wait, 0, function()
      timer:stop()
      vim.schedule(function()
        running = false
        f(unpack(last_args))
      end)
    end)
  end

  local cancel = function()
    if timer == nil then
      return
    end

    timer:stop()
    timer:close()
    timer = nil

    running = false
  end

  return wrapper, cancel
end

--- Returns true if object `f` can be called as a function.
---
---@param f? any
---@return boolean
function M.is_callable(f)
  if type(f) == "function" then
    return true
  end

  local mt = getmetatable(f)
  if mt == nil then
    return false
  end

  return type(rawget(mt, "__call")) == "function"
end

---@class utils.Lazy
---@field private _initialized boolean
---@field private _initializer fun(): unknown
---@field private _value unknown
local Lazy = {}

---@generic T
---@param f fun(): T
---@return T
function Lazy.new(f)
  local obj = {
    _initialized = false,
    _initializer = f,
    _value = {},
  }

  return setmetatable(obj, Lazy)
end

---@private
function Lazy:__call(...)
  Lazy._init(self)

  return self._value(...)
end

---@private
---@param self utils.Lazy
function Lazy:__index(key)
  Lazy._init(self)

  local meta = getmetatable(self._value)
  if meta and meta.__index then
    return meta.__index(self._value, key) or Lazy[key]
  elseif type(self._value) == "table" then
    return self._value[key] or Lazy[key]
  else
    return Lazy[key]
  end
end

---@private
---@param self utils.Lazy
function Lazy:__newindex(key, value)
  Lazy._init(self)

  self._value[key] = value
end

---@private
---@param self utils.Lazy
function Lazy:__tostring()
  local t = self._initialized and type(self._value) or "unknown"
  return "Lazy(" .. t .. ")"
end

---@private
function Lazy._init(lazy)
  if not lazy._initialized then
    lazy._value = lazy._initializer()
    lazy._initialized = true
  end
end

M.lazy = Lazy.new

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
