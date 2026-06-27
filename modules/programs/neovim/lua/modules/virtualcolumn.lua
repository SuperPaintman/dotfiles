--- @see https://github.com/lukas-reineke/virt-column.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local vim = _G.vim

local ns = vim.api.nvim_create_namespace('modules.virtualcolumn')

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@param winid integer
---@param bufnr integer
---@return integer[]?
local function parse_colorcolumn(winid, bufnr)
  local cc = vim.wo[winid].colorcolumn
  if cc == '' then
    return nil
  end

  local tw = vim.bo[bufnr].textwidth or 0

  local cols = {}

  for val in cc:gmatch('[^,]+') do
    local n = tonumber(val)
    if n then
      if val:match('^[+-]') then
        if tw > 0 then
          table.insert(cols, tw + n)
        end
      else
        table.insert(cols, n)
      end
    end
  end

  return cols
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------

---@class modules.virtualcolumn.Module
local M = {}

---@private
M._last = {
  winid = -1,
  bufnr = -1,
  cols = nil,
  leftcol = 0,
  tabstop = 8,
}

---@class modules.virtualcolumn.Config
M.options = {
  text = '┃',
  hl = 'VirtualColumn',
}

---@class modules.virtualcolumn.Config
M.defaults = vim.deepcopy(M.options)

--- _on_win is always called before the _on_line
---
---@private
---@param _ "win"
---@param winid integer
---@param bufnr integer
---@param toprow integer
---@param botrow integer
---@return boolean?
M._on_win = function(_, winid, bufnr, toprow, botrow)
  M._last.winid = winid
  M._last.bufnr = bufnr
  M._last.cols = parse_colorcolumn(winid, bufnr)
  M._last.leftcol = 0
  M._last.tabstop = 8

  if not M._last.cols or #M._last.cols == 0 then
    return false
  end

  M._last.leftcol = vim.fn.winsaveview().leftcol
  M._last.tabstop = vim.bo[bufnr].tabstop
end

---@private
---@param _ "line"
---@param winid integer
---@param bufnr integer
---@param row integer
M._on_line = function(_, winid, bufnr, row)
  if M._last.winid ~= winid or M._last.bufnr ~= bufnr then
    return
  end

  local cols = M._last.cols
  if not cols or #cols == 0 then
    return
  end

  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
  local leftcol = M._last.leftcol
  local tabstop = M._last.tabstop

  -- Compute display the line width.
  local dwidth = 0
  for i = 1, #line do
    if line:sub(i, i) == "\t" then
      dwidth = dwidth + tabstop - (dwidth % tabstop)
    else
      dwidth = dwidth + 1
    end
  end

  local virt_text = { { M.options.text, M.options.hl } }
  for _, col in ipairs(cols) do
    if dwidth < col then
      vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
        virt_text = virt_text,
        virt_text_win_col = col - 1 - leftcol,
        hl_mode = 'combine',
        priority = 1,
        ephemeral = true,
      })
    end
  end
end

---@param opts modules.virtualcolumn.Config?
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  vim.api.nvim_set_hl(0, 'VirtualColumn', { link = 'NonText', default = true })
  vim.api.nvim_set_hl(0, 'ColorColumn', { fg = 'NONE', bg = 'NONE', nocombine = true })

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = M._on_win,
    on_line = M._on_line,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
