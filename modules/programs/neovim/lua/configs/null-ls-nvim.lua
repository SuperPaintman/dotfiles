--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local null_ls = require("null-ls")
  local helpers = require("null-ls.helpers")
  local utils = require("null-ls.utils")

  null_ls.setup({
    sources = {
      -- Diagnostics
      -- null_ls.builtins.diagnostics.cspell,
      null_ls.builtins.diagnostics.gdlint,
      null_ls.builtins.diagnostics.staticcheck.with({
        cwd = helpers.cache.by_bufnr(function(params)
          return utils.root_pattern("go.work", "go.mod", ".git")(params.bufname)
        end),
      }),
      null_ls.builtins.diagnostics.statix,

      -- Formatting
      -- null_ls.builtins.formatting.gdformat,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.stylua,
    },
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
