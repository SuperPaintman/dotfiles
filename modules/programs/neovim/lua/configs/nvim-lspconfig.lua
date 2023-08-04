--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

local HOME = vim.env.HOME or ""

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@return table
local function get_default_client_capabilities()
  -- Default vim capabilities.
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Completion capabilities.
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      cmp_nvim_lsp.default_capabilities()
    )
  end

  return capabilities
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local lspconfig = require("lspconfig")

  local capabilities = get_default_client_capabilities()

  -- Go
  lspconfig.gopls.setup({
    capabilities = capabilities,

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
  local lua_ls_blacklist_runtime_files = {
    -- Avoid duplicates with the dotfiles.
    [vim.fs.normalize(HOME .. "/.config/nvim")] = true,
  }

  lspconfig.lua_ls.setup({
    capabilities = capabilities,

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
          -- Disable "Do you need to configure your work environment as".
          checkThirdParty = false,
          library = vim.tbl_filter(function(file)
            return not lua_ls_blacklist_runtime_files[file]
          end, vim.api.nvim_get_runtime_file("", true)),
        },
        semantic = {
          enable = false,

          -- Disable highlightning for type annotations.
          annotation = false,

          -- Disable highlightning for variables, fields, and parameters.
          variable = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- Nix
  lspconfig.rnix.setup({
    capabilities = capabilities,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
