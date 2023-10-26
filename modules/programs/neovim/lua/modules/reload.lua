--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local command = vim.api.nvim_create_user_command
local print_error = vim.api.nvim_err_writeln
local f = string.format

local M = {}

local RELOADABLE = {
  "configs.lsp_signature-nvim",
  "configs.luasnip",
  "configs.nvim-cmp",
}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class ReloadConfig
M.defaults = {}

---@param opts? ReloadConfig
M.setup = function(opts)
  local reload = require("utils.modules").reload
  local unload = require("utils.modules").unload

  command("Reload", function(opts)
    local module_name = opts.fargs[1]
    if not vim.tbl_contains(RELOADABLE, module_name) then
      print_error(f("Unknown module: %s", module_name))
      return
    end

    local ok, err = pcall(function()
      -- Unload common packages.
      unload("core.ui")

      -- Reload the module.
      local module = reload(module_name)

      if module.reload ~= nil then
        module.reload()
      elseif module.config ~= nil then
        module.config()
      else
        print_error(f("Module %s cannot be reloaded", module_name))
        return
      end
    end)
    if not ok then
      print_error(f("Failed to reload %s module: %s", module_name, err))
      return
    end
  end, {
    desc = "Reload a neovim module",
    nargs = 1,
    complete = function()
      return RELOADABLE
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
