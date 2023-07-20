--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
---@class utils.mappings.Module
local M = {}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias utils.mappings.Fallback fun()

---@alias utils.mappings.Callback fun()

---@alias utils.mappings.Handler fun(fallback: utils.mappings.Fallback)

---@alias utils.mappings.Initializer fun(fallback?: utils.mappings.Fallback): utils.mappings.Callback

---@alias utils.mappings.IsInitializedFunc fun(): boolean

---@alias utils.mappings.IsInitialized
---| utils.mappings.IsInitializedFunc
---| {_initialized: boolean}
---| {initialized: boolean}

---@alias utils.mappings.CallbackFactory fun(handler: utils.mappings.Handler): utils.mappings.Initializer

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param msg string?
---@return utils.mappings.Fallback
local function create_default_fallback(msg)
  ---@type string
  msg = msg or "Mapping is not initialized"

  return function()
    vim.api.nvim_notify(msg, vim.log.levels.WARN, {})
  end
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@param f utils.mappings.Handler
---@param is_initialized utils.mappings.IsInitialized?
---@param msg string?
---@return utils.mappings.Initializer
M.create_callback = function(f, is_initialized, msg)
  if is_initialized == nil then
    return function(fallback)
      ---@type utils.mappings.Fallback
      fallback = fallback or create_default_fallback(msg)

      return function()
        f(fallback)
      end
    end
  end

  if type(is_initialized) == "table" then
    if type(is_initialized._initialized) == "boolean" then
      local m = is_initialized
      ---@type utils.mappings.IsInitializedFunc
      is_initialized = function()
        return m._initialized
      end
    elseif type(is_initialized.initialized) == "boolean" then
      local m = is_initialized
      ---@type utils.mappings.IsInitializedFunc
      is_initialized = function()
        return m.initialized
      end
    end
  end

  return function(fallback)
    ---@type utils.mappings.Fallback
    fallback = fallback or create_default_fallback(msg)

    return function()
      ---@cast is_initialized utils.mappings.IsInitializedFunc
      if not is_initialized() then
        fallback()
        return
      end

      f(fallback)
    end
  end
end

---@param is_initialized utils.mappings.IsInitialized?
---@param msg string?
---@return utils.mappings.CallbackFactory
M.create_callback_factory = function(is_initialized, msg)
  return function(f)
    return M.create_callback(f, is_initialized, msg)
  end
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
