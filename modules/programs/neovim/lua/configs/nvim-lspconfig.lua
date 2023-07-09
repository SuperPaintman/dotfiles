--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local lspconfig = require("lspconfig")

  -- Go
  lspconfig.gopls.setup({
    -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    settings = {
      gopls = {
        -- See: https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        analyses = {
          unusedparams = true,
          unusedwrite = true,
        },
      },
    },
  })

  -- Lua
  lspconfig.lua_ls.setup({
    -- See: https://github.com/LuaLS/lua-language-server/wiki/Settings
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Disables "Do you need to configure your work environment as".
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
