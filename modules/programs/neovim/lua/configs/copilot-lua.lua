--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.lazy = true

M.cmd = "Copilot"

M.config = function()
  if vim.fn.executable("bubblewrap-copilot") ~= 1 then
    return
  end

  require("copilot").setup({
    copilot_node_command = "bubblewrap-copilot",
    server_opts_overrides = {
      cmd = {
        "bubblewrap-copilot",
        "/opt/copilot/index.js",
      },

      trace = "verbose",

      settings = {
        advanced = {
          inlineSuggestCount = 3,
        },
      },
    },

    suggestion = { enabled = false }, -- Use copilot-cmp instead.
    panel = { enabled = false }, -- Use copilot-cmp instead.

    filetypes = {
      -- TODO(SuperPaintman): add validation to prevent secrets from leaking.
      go = true,
      javascript = true,
      typescript = true,
      zig = true,
      ["*"] = false, -- Disable for all other filetypes and ignore default `filetypes`.
    },
  })

  -- Setup copilot-cmp.
  -- require("copilot_cmp").setup()
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
