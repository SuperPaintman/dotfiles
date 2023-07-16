--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param msg string?
local function create_default_fallback(msg)
  msg = msg or "Mapping is not initialized"

  return function()
    vim.api.nvim_notify(msg, vim.log.levels.WARN, {})
  end
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@param f function
---@param is_initialized (function | {_initialized:boolean} | {initialized:boolean})?
---@param msg string?
---@return function
M.create_callback = function(f, is_initialized, msg)
  if is_initialized == nil then
    return function(fallback)
      fallback = fallback or create_default_fallback(msg)

      return function()
        f(fallback)
      end
    end
  end

  if type(is_initialized) == "table" then
    if type(is_initialized._initialized) == "boolean" then
      local m = is_initialized
      is_initialized = function()
        return m._initialized
      end
    elseif type(is_initialized.initialized) == "boolean" then
      local m = is_initialized
      is_initialized = function()
        return m.initialized
      end
    end
  end

  return function(fallback)
    fallback = fallback or create_default_fallback(msg)

    return function()
      if not is_initialized() then
        fallback()
        return
      end

      f(fallback)
    end
  end
end

---@param is_initialized (function | {_initialized:boolean} | {initialized:boolean})?
---@param msg string?
---@return function
M.create_callback_factory = function(is_initialized, msg)
  return function(f)
    return M.create_callback(f, is_initialized, msg)
  end
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
