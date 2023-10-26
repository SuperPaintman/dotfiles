--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = false,
}

local cb = require("utils.mappings").create_callback_factory(
  M,
  "luasnip is not initialized"
)

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
    "snippets.gdscript",
    "snippets.go",
  }) do
    require(mod).setup()
  end

  M._initialized = true
end

M.reload = function()
  local luasnip = require("luasnip")
  luasnip.cleanup()

  local unload = require("utils.modules").unload
  unload("^snippets%.", true)
  M.config()
end

M.mappings = {
  expand_or_jump = cb(function()
    local luasnip = require("luasnip")
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    end
  end),

  jump_back = cb(function()
    local luasnip = require("luasnip")
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
