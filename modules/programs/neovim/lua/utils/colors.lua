--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Classes
--------------------------------------------------------------------------------

---@class utils.colors.RGB
---@field r number
---@field g number
---@field b number
local RGB = {}
RGB.__index = RGB
M.RGB = RGB

--- Creates a new RGB instance.
---@param r number Red component (0-255).
---@param g number Green component (0-255).
---@param b number Blue component (0-255).
---@return utils.colors.RGB
---@overload fun(hex: string): utils.colors.RGB
function RGB.new(r, g, b)
  if type(r) == "string" then
    local hex = r:gsub("^#", "")
    local n = tonumber(hex, 16)
    if n == nil then
      error("utils.colors.RGB: failed to parse hex color")
    end

    r = bit.band(bit.rshift(n, 16), 0xFF)
    g = bit.band(bit.rshift(n, 8), 0xFF)
    b = bit.band(n, 0xFF)
  else
    r = math.floor(r)
    g = math.floor(g)
    b = math.floor(b)
  end

  ---@type utils.colors.RGB
  local self = {
    r = r,
    g = g,
    b = b,
  }

  return setmetatable(self, RGB)
end

--- Returns the string representation of the RGB.
---@return string
function RGB:__tostring()
  return string.format("RGB(%d, %d, %d)", self.r, self.g, self.b)
end

--- Returns the hex representation of the RGB.
---@return string
function RGB:to_hex()
  return string.format("#%02X%02X%02X", self.r, self.g, self.b)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
