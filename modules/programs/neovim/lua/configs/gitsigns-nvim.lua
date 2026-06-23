-- See: https://github.com/lewis6991/gitsigns.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = true,
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local cb = require("utils.mappings").create_callback_factory(
  M,
  "gitsigns is not initialized"
)

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@param buf integer
---@return boolean
local function is_buf_gitsigns(buf)
  buf = buf or 0

  local name = vim.api.nvim_buf_get_name(buf)
  if name:match("^gitsigns://") then
    return true
  end

  return false
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.lazy = true

M.event = "VeryLazy"

--- Toggles the diff view.
M._toggle_diffthis = function()
  local wins_all = vim.api.nvim_tabpage_list_wins(0)
  local wins_gitsigns = {}
  for _, win in ipairs(wins_all) do
    if is_buf_gitsigns(vim.api.nvim_win_get_buf(win)) then
      table.insert(wins_gitsigns, win)
    end
  end

  local should_open = not (
    is_buf_gitsigns(0)                      -- Current window is the "left" view.
    or (#wins_gitsigns > 0 and vim.wo.diff) -- Current window is "right" view.
  )

  -- Close already opened gitsign windows.
  for _, win in ipairs(wins_gitsigns) do
    if vim.api.nvim_win_is_valid(win) then
      pcall(function()
        vim.api.nvim_win_close(win, false)
      end)
    end
  end

  for _, win in ipairs(wins_all) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function()
        if vim.wo.diff then
          vim.cmd("diffoff")
        end
      end)
    end
  end

  if should_open then
    require("gitsigns").diffthis()
  end
end

M.config = function()
  require("gitsigns").setup({
    signs                        = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },

    signs_staged                 = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable          = false,

    signcolumn                   = true,
    numhl                        = false,
    linehl                       = false,
    word_diff                    = false,

    watch_gitdir                 = {
      follow_files = true,
    },

    auto_attach                  = true,
    attach_to_untracked          = false,
    current_line_blame           = false,

    current_line_blame_opts      = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },

    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    blame_formatter              = nil,
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,
    max_file_length              = 40000,

    preview_config               = {
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
  })

  autocmd({ "BufWinEnter", "WinEnter" }, {
    group = augroup("GitsignsDiffInvert", { clear = true }),
    callback = function(ev)
      if not is_buf_gitsigns(ev.buf) then
        return
      end
      local win = vim.fn.bufwinid(ev.buf)
      if win == -1 then
        return
      end

      vim.wo[win].winhighlight = table.concat({
        "DiffAdd:GitSignsDiffAddLeft",
        "DiffDelete:GitSignsDiffDeleteLeft",
      }, ",")
    end,
  })

  M._initialized = true
end

M.mappings = {
  diff = cb(function()
    M._toggle_diffthis()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
