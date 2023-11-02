-- See: https://lodash.com/docs/4.17.15
--------------------------------------------------------------------------------
-- Init
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

---@class utils.Lazy
---@field private _initialized boolean
---@field private _initializer fun(): unknown
---@field private _value unknown
---@field private _mt table
local Lazy = { mt = {} }

---@generic T
---@param f fun() T
---@return T
function Lazy.new(f)
  ---@type utils.Lazy
  local obj = {
    _initialized = false,
    _initializer = f,
    _value = {},
  }

  return setmetatable(obj, Lazy.mt)
end

function Lazy.mt:__call(...)
  Lazy._init(self)

  return self._value(...)
end

function Lazy.mt:__index(key)
  Lazy._init(self)

  local meta = getmetatable(self._value)
  if meta and meta.__index then
    return meta.__index(self._value, key) or Lazy.mt[key]
  elseif type(self._value) == "table" then
    return self._value[key] or Lazy.mt[key]
  else
    return Lazy.mt[key]
  end
end

function Lazy.mt:__newindex(key, value)
  Lazy._init(self)

  self._value[key] = value
end

function Lazy.mt:__tostring()
  return "Lazy"
end

---@private
function Lazy._init(lazy)
  if not lazy._initialized then
    lazy._value = lazy._initializer()
    lazy._initialized = true
  end
end

---@generic T
---@param f fun(): T
---@return T
M.lazy = function(f)
  return Lazy.new(f)
end

---@param modname string
---@return unknown
M.lazy_require = function(modname)
  return M.lazy(function()
    return require(modname)
  end)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
