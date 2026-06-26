--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local vim = _G.vim
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

-- Only show cursorline in the active window.
do
  local group = augroup("ShowCursorlineOnlyInActive", { clear = true })

  autocmd({
    "WinEnter",
    "BufEnter",
    "FocusGained", -- Respect tmux focus-events.
    -- "InsertLeave", -- (?) and hide it in the insert mode. But I don't like how it looks.
  }, {
    group = group,
    callback = function()
      if vim.w.restore_cursorline then
        vim.wo.cursorline = true
        vim.w.auto_cursorline = nil
      end
    end,
  })

  autocmd({
    "WinLeave",
    "BufLeave",
    "FocusLost",
    -- "InsertEnter",
  }, {
    group = group,
    callback = function()
      if vim.wo.cursorline then
        vim.w.restore_cursorline = true
        vim.wo.cursorline = false
      end
    end,
  })
end

patch_filetype("GodotConfig", "dosini", { "project.godot" })

patch_filetype("GodotImport", "gdresource", { "*.import" })
