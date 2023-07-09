--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local luasnip = require("luasnip")

  -- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#config-options
  luasnip.config.setup({
    history = false,

    -- Update snippets on every change.
    update_events = { "TextChanged", "TextChangedI" },
  })

  -- Add snippets.
  -- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#config-reference
  for _, mod in ipairs({
    "snippets.all",
    "snippets.go",
  }) do
    require(mod).setup()
  end
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
