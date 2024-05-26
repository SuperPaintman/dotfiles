--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

if false then
  -- See: https://lunarmodules.github.io/busted/

  ---@type fun(msg: string, cb: fun())
  _G.describe = _G.describe

  ---@type fun(msg: string, cb: fun())
  _G.it = _G.it

  ---@type fun(cb: fun())
  _G.before_each = _G.before_each

  ---@type fun(cb: fun())
  _G.after_each = _G.after_each

  ---@type fun(v: any)
  assert.is_nil = assert.is_nil

  ---@type fun(want: any, got: any)
  assert.same = assert.same
end

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param root string
---@return string
local function get_root(root)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (root or "")
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
vim.env.XDG_CONFIG_HOME = get_root(".tests/config")
vim.env.XDG_DATA_HOME = get_root(".tests/data")
vim.env.XDG_STATE_HOME = get_root(".tests/state")
vim.env.XDG_CACHE_HOME = get_root(".tests/cache")

-- Append current dir.
local cwd = vim.fn.getcwd()
package.path = table.concat({
  cwd .. "/lua/?.lua",
  cwd .. "/lua/?/init.lua",
  cwd .. "/extensions/?/target/debug/lib?.so",
  package.path,
}, ";")

require("init-native-extensions")
require("core.options")
require("lazyinit")
