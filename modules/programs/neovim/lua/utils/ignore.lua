--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local glob = require("glob")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

---@alias utils.ignore.Ignore {pattern: string, allowed: boolean}

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

---@param content string[]
---@return utils.ignore.Ignore[]
M.parse = function(content)
  local ignores = {}

  for _, line in ipairs(content) do
    local trimmed = line:match("^(.-)%s*$")

    -- Skip comments and empty lines
    if trimmed ~= "" and not trimmed:match("^#") then
      local allowed = false

      -- Handle negation pattern
      if trimmed:sub(1, 1) == "!" then
        allowed = true
        trimmed = trimmed:sub(2)
      end

      table.insert(ignores, { pattern = trimmed, allowed = allowed })
    end
  end

  return ignores
end

---@param pattern string
---@param filename string
---@return boolean
M.matches = function(pattern, filename)
  local ok, match = pcall(function()
    return glob.matches(pattern, filename)
  end)

  if not ok then
    return false
  end

  return match
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
