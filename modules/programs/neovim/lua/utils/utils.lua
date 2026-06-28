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
-- Number
--------------------------------------------------------------------------------

--- Returns true if `v` is an integer.
---
---@param v any
---@return boolean
M.is_integer = function(v)
  return type(v) == "number" and (v % 1 == 0)
end

--------------------------------------------------------------------------------
-- Table
--------------------------------------------------------------------------------

---@generic T
---@generic R
---@param arr T[]
---@param f fun(v: T): R
---@return R[]
M.map = function(arr, f)
  local res = {}

  -- Preserve the non-array part of the table.
  for k, v in pairs(arr) do
    res[k] = v
  end

  for i, v in ipairs(arr) do
    res[i] = f(v)
  end

  return res
end

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

--- A fixed-capacity ring buffer.
---
---@class utils.RingBuffer<T>
---@field private _buf T[]
---@field private _cap integer
---@field private _head integer
---@field private _count integer
local RingBuffer = {}
---@private
RingBuffer.__index = RingBuffer
M.RingBuffer = RingBuffer

--- Creates a new ring buffer with the given capacity.
---
---@generic T
---@param capacity integer
---@return utils.RingBuffer<T>
function RingBuffer.new(capacity)
  assert(M.is_integer(capacity), "capacity must be an integer")
  assert(capacity >= 1, "capacity must be a positive integer")

  return setmetatable({
    _buf   = {},
    _cap   = capacity,
    _head  = 1,
    _count = 0,
  }, RingBuffer)
end

--- Pushes a value into the buffer. If buffer is full then overwrites the
--- oldest element.
---
---@generic T
---@param self utils.RingBuffer<T>
---@param value T
function RingBuffer:push(value)
  if value == nil then
    return
  end

  if self._count == self._cap then
    local pos = self._head
    self._buf[pos] = value
    self._head = self._head % self._cap + 1
  else
    local pos = (self._head + self._count - 1) % self._cap + 1
    self._buf[pos] = value
    self._count = self._count + 1
  end
end

--- Removes and return the oldest element.
---
---@generic T
---@return T? value -- nil if empty
function RingBuffer:pop()
  if self._count == 0 then
    return nil
  end

  local value = self._buf[self._head]
  self._buf[self._head] = nil
  self._head = self._head % self._cap + 1
  self._count = self._count - 1
  return value
end

---@generic T
---@private
---@param i? integer
---@return integer?
---@return T?
function RingBuffer:_iter_next(i)
  i = i or 0
  if i >= self._count then
    return nil
  end

  i = i + 1
  return i, self._buf[(self._head + i - 2) % self._cap + 1]
end

--- Returns an iterator over elements oldest-to-newest.
---
--- Doesn't modyfy the ring buffer.
---
---@generic T
---@return fun(b: utils.RingBuffer<T>, i?: integer): integer, T
---@return utils.RingBuffer<T>
---@return integer
function RingBuffer:iter()
  return self._iter_next, self, 0
end

--- Returns the ring buffer capacity.
---
---@return integer
function RingBuffer:cap() return self._cap end

--- Returns the number of stored elements in the ring buffer.
---
---@return integer
function RingBuffer:len() return self._count end

--- Returns `true` when the ring buffer is empty.
---
---@return boolean
function RingBuffer:empty() return self._count == 0 end

--- Returns `true` when the ring buffer is full.
---
---@return boolean
function RingBuffer:full() return self._count == self._cap end

--- Removes all elements from the ring buffer.
function RingBuffer:clear()
  for k = 1, self._cap do
    self._buf[k] = nil
  end

  self._head = 1
  self._count = 0
end

---@private
---@return string
function RingBuffer:__tostring()
  return string.format("RingBuffer(%d/%d)", self._count, self._cap)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
