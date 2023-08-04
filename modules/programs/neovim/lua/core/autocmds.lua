--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--------------------------------------------------------------------------------
-- Auto commands
--------------------------------------------------------------------------------
-- TODO(SuperPaintman): watch files with `vim.loop.fs_event_start()`.
autocmd({ "BufEnter", "BufLeave", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = augroup("CheckIfFileChanged", { clear = true }),
  desc = "Check if the current file has been changed outside of Vim and reload it",
  command = ":checktime",
})
