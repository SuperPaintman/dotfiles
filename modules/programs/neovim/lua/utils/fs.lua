--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local uv = vim.loop

local M = {}

--- Taken from plenary.nvim
---
---@see https://github.com/nvim-lua/plenary.nvim/blob/a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683/lua/plenary/path.lua#L21-L32
M.sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os ~= "windows" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

--- Taken from plenary.nvim
---
---@see https://github.com/nvim-lua/plenary.nvim/blob/a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683/lua/plenary/path.lua#L21-L32
local get_parent = (function()
  local formatted = string.format("^(.+)%s[^%s]+", M.sep, M.sep)

  ---@param path string
  ---@return string
  return function(path)
    local parent = path:match(formatted)
    if parent ~= nil and not parent:find(M.sep) then
      return parent
    end
    return parent
  end
end)()

--- Taken from plenary.nvim
---
---@param filename string
---@param sep string?
---@return boolean
---
---@see https://github.com/nvim-lua/plenary.nvim/blob/a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683/lua/plenary/path.lua#L79-L84
local function is_absolute(filename, sep)
  if sep == nil then
    sep = M.sep
  end

  if sep == "\\" then
    return string.match(filename, "^[%a]:[\\/].*$") ~= nil
  end
  return string.sub(filename, 1, 1) == sep
end

---@param filename string
---@param sep string?
---@return boolean
local function is_relative(filename, sep)
  return not is_absolute(filename, sep)
end

---@param filename string
---@return string
local function normalize(filename)
  return vim.fs.normalize(filename)
end

---@param filename string
---@return boolean
local function exists(filename)
  local ok = uv.fs_stat(filename)
  return not not ok
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

--- Read file and return its content as an array of lines.
---
---@param filename string
---@return string[]
function M.read(filename)
  local f = assert(uv.fs_open(filename, "r", 292)) -- 0444

  local stat = assert(uv.fs_fstat(f))

  ---@type string
  local data = assert(uv.fs_read(f, stat.size, 0))

  assert(uv.fs_close(f))

  ---@type string[]
  local lines = {}
  for s in data:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  return lines
end

--- Creates an iterator that returns the ancestors of a path.
---
--- If the `inclusive` parameter is set to `true`, the top-level path will be
--- included.
---
---@param root string
---@param inclusive boolean?
---@return fun(): number, string
function M.ancestors_iter(root, inclusive)
  inclusive = inclusive or true

  local is_rel = is_relative(root)
  local returned_root = false

  local MAX_DEPTH = 999
  local depth = 0

  if not inclusive then
    root = get_parent(root)
  end

  local iter = function()
    -- Prevent infinite iterator
    depth = depth + 1
    if depth > MAX_DEPTH then
      return
    end

    if not root then
      if not returned_root then
        returned_root = true

        if is_rel then
          return depth, "."
        else
          return depth, M.sep
        end
      end

      return
    end

    local current = root
    root = get_parent(root)

    return depth, current
  end

  return iter
end

---@param patterns string[]
local function ancestor_matcher(patterns)
  ---@param path string
  ---@return boolean
  return function(path)
    for _, pattern in ipairs(patterns) do
      local filename = path
      if filename ~= M.sep then
        filename = filename .. M.sep
      end
      filename = filename .. pattern

      if exists(path .. M.sep .. pattern) then
        return true
      end
    end

    return false
  end
end

---@param root string
---@param fn fun(path: string): boolean
---@return string[]
function M.find_ancestors_func(root, fn)
  root = normalize(root)

  local res = {}

  for _, path in M.ancestors_iter(root, true) do
    if fn(path) then
      table.insert(res, path)
    end
  end

  return res
end

---@param root string
---@param patterns string[]
---@return string[]
function M.find_ancestors(root, patterns)
  return M.find_ancestors_func(root, ancestor_matcher(patterns))
end

---@param root string
---@param fn fun(path: string): boolean
---@return string|nil
function M.find_ancestor_func(root, fn)
  root = normalize(root)

  for _, path in M.ancestors_iter(root, true) do
    if fn(path) then
      return path
    end
  end

  return nil
end

---@param root string
---@param patterns string[]
---@return string|nil
function M.find_ancestor(root, patterns)
  return M.find_ancestor_func(root, ancestor_matcher(patterns))
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
