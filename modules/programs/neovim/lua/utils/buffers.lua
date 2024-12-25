--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------

--- Returns the size of the file in the buffer.
---
--- The function returns 0 as the size if the buffer does not have file.
---
---@param bufnr string?
---@return number, boolean
function M.file_size(bufnr)
  -- Get the current buffer
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local ok, stats = pcall(vim.loop.fs_stat, filepath)
  if not ok or not stats then
    return 0, false
  end

  return stats.size, true
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
