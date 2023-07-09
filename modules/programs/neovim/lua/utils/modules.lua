--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.unload = function(name, regexp)
  -- Defaults.
  if regexp == nil then
    regexp = false
  end

  -- Create a matcher.
  local matcher
  if regexp then
    matcher = function(pack)
      return string.find(pack, name)
    end
  else
    matcher = function(pack)
      return pack == name
    end
  end

  -- Handle impatient.nvim automatically.
  local luacache = (_G.__luacache or {}).cache

  for pack, _ in pairs(package.loaded) do
    if matcher(pack) then
      package.loaded[pack] = nil

      if luacache then
        luacache[pack] = nil
      end
    end
  end
end

M.reload = function(name)
  M.unload(name, false)
  return require(name)
end

M.is_available = function(name)
  if package.loaded[name] ~= nil then
    return true
  end

  local ok = pcall(require, name)
  return ok
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
