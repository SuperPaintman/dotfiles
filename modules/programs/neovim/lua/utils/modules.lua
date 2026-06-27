--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local vim = _G.vim
local package = _G.package

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
local M = {}

---@param modname string
---@param regexp boolean?
M.unload = function(modname, regexp)
  regexp = regexp ~= false and true or false

  -- Create a matcher.
  local matcher
  if regexp then
    matcher = function(pack)
      return string.find(pack, modname)
    end
  else
    matcher = function(pack)
      return pack == modname
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

---@param modname string
---@return unknown
M.reload = function(modname)
  M.unload(modname, false)
  return require(modname)
end

---@param modname string
---@return boolean
M.is_loaded = function(modname)
  return package.loaded[modname] ~= nil
end

---@param modname string
---@return boolean
M.is_available = function(modname)
  if M.is_loaded(modname) then
    return true
  end

  -- -- TODO(SuperPaintman): don't actually load the module.
  -- local ok = pcall(require, modname)
  -- return ok

  local p = nil

  p, _ = package.searchpath(modname, package.path)
  if p ~= nil then
    return true
  end

  p, _ = package.searchpath(modname, package.cpath)
  if p ~= nil then
    return true
  end

  for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
    p, _ = package.searchpath(modname, path .. "/lua/?.lua" .. ";" .. path .. "/lua/?/init.lua")
    if p ~= nil then
      return true
    end
  end

  -- TODO(SuperPaintman): add support for Lazy plugins.

  return false
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
