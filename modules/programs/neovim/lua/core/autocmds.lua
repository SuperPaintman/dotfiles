--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function patch_filetype(name, filetype, pattern)
  autocmd({ "BufNewFile", "BufRead" }, {
    group = augroup("SetFileType" .. name, { clear = true }),
    pattern = pattern,
    desc = "Set filetype for " .. name,
    callback = function()
      vim.opt_local.filetype = filetype
    end,
  })
end

--------------------------------------------------------------------------------
-- Auto commands
--------------------------------------------------------------------------------
-- TODO(SuperPaintman): watch files with `vim.loop.fs_event_start()`.
autocmd({ "BufEnter", "BufLeave", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = augroup("CheckIfFileChanged", { clear = true }),
  desc = "Check if the current file has been changed outside of Vim and reload it",
  command = ":checktime",
})

patch_filetype("GodotConfig", "dosini", { "project.godot" })

patch_filetype("GodotImport", "gdresource", { "*.import" })
