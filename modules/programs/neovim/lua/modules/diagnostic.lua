-- TODO(SuperPaintman):
--     Add a custom popup window different colors.
--     The "native" popup implimentation can only highlight the entire line.
--
--     See: https://github.com/neovim/neovim/blob/cc87dda31a5b5637ade7ddcfe5199f2df5fd47df/runtime/lua/vim/diagnostic.lua#L1007C28-L1007C49
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@class module.diagnostic.Module
local M = {}

local OK = 5

local signs = {
  [vim.diagnostic.severity.ERROR] = {
    name = "DiagnosticSignError",
    text = ui.icons.diagnostic.Error,
  },
  [vim.diagnostic.severity.WARN] = {
    name = "DiagnosticSignWarn",
    text = ui.icons.diagnostic.Warn,
  },
  [vim.diagnostic.severity.INFO] = {
    name = "DiagnosticSignInfo",
    text = ui.icons.diagnostic.Info,
  },
  [vim.diagnostic.severity.HINT] = {
    name = "DiagnosticSignHint",
    text = ui.icons.diagnostic.Hint,
  },
  [OK] = {
    name = "DiagnosticSignOk",
    text = ui.icons.diagnostic.Ok,
  },
}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@class module.diagnostic.Diagnostic
---@field _tags table?
---@field bufnr number
---@field code string
---@field col number
---@field end_col number
---@field lnum number
---@field message string
---@field severity number
---@field source string
---@field user_data table?

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@param opts table?
M.setup = function(opts)
  -- Define diagnostic sings.
  for _, sign in pairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = "" }
    )
  end

  -- Configure diagnostic options.
  vim.diagnostic.config({
    -- Use underline for diagnostics.
    underline = true,
    -- Use virtual text for diagnostics.
    virtual_text = false,
    -- Use signs for diagnostics.
    signs = true,
    -- Update diagnostics in Insert mode.
    update_in_insert = true,
    -- Sort diagnostics by severity.
    severity_sort = true,

    float = {
      style = "minimal",
      -- TODO(SuperPaintman): Add a custom highlight group.
      border = ui.borders.thick("VertSplit"),
      header = false,
      source = false,
      prefix = "",
      ---@param diagnostic module.diagnostic.Diagnostic
      format = function(diagnostic)
        diagnostic.user_data = diagnostic.user_data or {}
        diagnostic.user_data.orig_message = diagnostic.message

        local icon = nil
        local sign = signs[diagnostic.severity] or signs[OK]

        if sign ~= nil then
          icon = sign.text
        end

        if icon == nil or icon == "" then
          icon = "?"
        end

        return icon .. "  "
      end,
      ---@param diagnostic module.diagnostic.Diagnostic
      suffix = function(diagnostic)
        local suffix = diagnostic.user_data.orig_message

        if diagnostic.code ~= nil or diagnostic.source ~= nil then
          suffix = suffix .. " ["

          if diagnostic.source ~= nil then
            suffix = suffix .. diagnostic.source
          end
          if diagnostic.code ~= nil then
            if diagnostic.source then
              suffix = suffix .. ": "
            end

            suffix = suffix .. diagnostic.code
          end

          suffix = suffix .. "]"
        end

        suffix = string.gsub(suffix, "[\n\r]", " ")
        suffix = string.gsub(suffix, "[ ]+", " ")

        return suffix
      end,
    },
  })

  -- Add the "auto-hover".
  autocmd("CursorHold", {
    group = augroup("DiagnosticAutoHover", { clear = true }),
    desc = "Auto opening of the diagnostic float window",
    callback = function()
      vim.diagnostic.open_float()
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
