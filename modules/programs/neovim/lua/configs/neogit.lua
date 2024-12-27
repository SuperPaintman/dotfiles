-- See: https://github.com/NeogitOrg/neogit
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = true, -- TODO(SuperPaintman): remove it.
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local cb = require("utils.mappings").create_callback_factory(
  M,
  "neogit is not initialized"
)

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "nvim-lua/plenary.nvim", -- required
  "nvim-telescope/telescope.nvim", -- optional
  "sindrets/diffview.nvim", -- optional
  -- "ibhagwan/fzf-lua", -- optional
}

M.lazy = true

M.cmd = "Neogit"

M.config = function()
  require("neogit").setup({
    disable_hint = true,
    signs = {
      section = { ui.icons.common.Collapsed, ui.icons.common.Expanded },
      item = { ui.icons.common.Collapsed, ui.icons.common.Expanded },
      hunk = { "", "" },
    },
  })

  autocmd("BufEnter", {
    group = augroup("ConfigsNeogitStatusOptions", { clear = true }),
    pattern = "NeogitStatus",
    callback = function()
      local winid = vim.api.nvim_get_current_win()

      -- Disable column highlighting.
      vim.wo[winid].colorcolumn = false

      -- Hide special characters.
      vim.wo[winid].list = false
      vim.wo[winid].listchars = false
    end,
  })

  M._initialized = true
end

M.mappings = {
  open = cb(function()
    -- TODO(SuperPaintman): add a helper for lazy loading.
    require("lazy").load({ plugins = { "neogit" }, wait = true })
    require("neogit").open({})
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
