-- See: https://github.com/esmuellert/codediff.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = true,
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
        quit = "<C-c>", -- TODO(SuperPaintman): close by :q
      },
    },

    explorer = {
      initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
      focus_on_select = true,
    },
  })

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

  M._initialized = true
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
