--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param v number
---@param min number
---@param max number
---@return number
local function clamp(v, min, max)
  return math.max(min, math.min(max, v))
end

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
    r = clamp(math.floor(r), 0, 255)
    g = clamp(math.floor(g), 0, 255)
    b = clamp(math.floor(b), 0, 255)
  end

  local self = {
    r = r,
    g = g,
    b = b,
  }

  return setmetatable(self, RGB)
end

--- Returns the string representation of the RGB.
---@private
---@return string
function RGB:__tostring()
  return string.format("RGB(%d, %d, %d)", self.r, self.g, self.b)
end

--- Returns the hex representation of the RGB.
---@return string
function RGB:to_hex()
  return string.format("#%02X%02X%02X", self.r, self.g, self.b)
end

--- Mixes two RGB colors by a given amount (0 to 1).
--- @param color utils.colors.RGB
--- @param amount number
--- @return utils.colors.RGB
function RGB:mix(color, amount)
  amount = clamp(amount, 0, 1)

  local r = (color.r - self.r) * amount + self.r
  local g = (color.g - self.g) * amount + self.g
  local b = (color.b - self.b) * amount + self.b

  return RGB.new(r, g, b)
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--- Mixes two colors by a given amount (0 to 1).
--- @param color1 string
--- @param color2 string
--- @param amount number
--- @return string
function M.mix(color1, color2, amount)
  local c1 = RGB.new(color1)
  local c2 = RGB.new(color2)

  local c = c1:mix(c2, amount)

  return c:to_hex()
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
