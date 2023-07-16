-- See: https://github.com/rmagatti/auto-session
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function find_file_in_nvimtree()
  -- TODO(SuperPaintman): Open the Nvim Tree only if it was open in this session.

  local ok, nvimtree = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  local nvimtree_api = require("nvim-tree.api")
  nvimtree.change_dir(vim.fn.getcwd())
  nvimtree_api.tree.find_file({
    open = true,
    focus = false,
  })
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  require("auto-session").setup({
    auto_session_enable_last_session = false,
    auto_session_enabled = true,
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = false,
    auto_session_use_git_branch = false,
    post_cwd_changed_hook = function()
      -- Refresh the lualine.
      local ok, lualine = pcall(require, "lualine")
      if ok then
        lualine.refresh()
      end
    end,
    post_restore_cmds = {
      find_file_in_nvimtree,
    },
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
