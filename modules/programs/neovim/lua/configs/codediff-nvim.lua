-- See: https://github.com/esmuellert/codediff.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = false,
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.lazy = true

M.cmd = "CodeDiff"

M.config = function()
  require("codediff").setup({
    keymaps = {
      view = {
        quit = false,                   -- "q", -- TODO(SuperPaintman): close by :q
        toggle_explorer = "<leader>gd", -- "<leader>b",
        focus_explorer = false,         -- "<leader>e",
      },
    },

    explorer = {
      initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
      focus_on_select = true,
    },
  })

  local lifecycle = require("codediff.ui.lifecycle")

  autocmd("BufWinEnter", {
    group = augroup("CodeDiffExplorerInit", { clear = true }),
    callback = function(ev)
      if vim.bo[ev.buf].filetype ~= "codediff-explorer" then
        return
      end

      local win = vim.fn.bufwinid(ev.buf)
      if win == -1 then
        return
      end

      vim.wo[win].winhighlight = table.concat({
        "Normal:CodeDiffExplorerNormal",
        "NormalNC:CodeDiffExplorerNormalNC",
      }, ",")
    end,
  })

  -- Close the CodeDiff tab if one of the windows there is closed.
  autocmd("WinClosed", {
    group = augroup("CodeDiffWinClose", { clear = true }),
    callback = function(ev)
      local win = tonumber(ev.match)
      if not win then
        return
      end

      local ok, tab = pcall(vim.api.nvim_win_get_tabpage, win)
      if not ok then
        return
      end

      local sess = lifecycle.get_session(tab)
      if not sess then
        return
      end

      if win ~= sess.original_win and win ~= sess.modified_win and win ~= sess.result_win then
        return
      end

      vim.schedule(function()
        if not vim.api.nvim_tabpage_is_valid(tab) then
          return
        end

        -- for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        --   vim.api.nvim_win_close(w, false)
        -- end

        -- Check for unsaved conflict files before closing
        if not lifecycle.confirm_close_with_unsaved(tab) then
          return -- User cancelled
        end

        if #vim.api.nvim_list_tabpages() == 1 then
          lifecycle.cleanup_for_quit(tab)
          vim.cmd("qall")
        else
          vim.cmd("tabclose")
        end
      end)
    end,
  })

  M._initialized = true
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
