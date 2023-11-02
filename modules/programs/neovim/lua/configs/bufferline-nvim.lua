--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

local M = {}

local signs = {
  error = ui.icons.diagnostic.Error,
  warning = ui.icons.diagnostic.Warn,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function close_not_pinned()
  local bufferline_ui = require("bufferline.ui")
  local state = require("bufferline.state")
  local commands = require("bufferline.commands")
  local groups = require("bufferline.groups")

  local index = commands.get_current_element_index(state)
  if not index then
    return
  end

  local current_buffer = vim.api.nvim_get_current_buf()
  local buffers = {}

  for i, item in ipairs(state.components) do
    local element = item:as_element()
    if element then
      local keep = element.id == current_buffer
        or element.modified
        or groups._is_pinned(element)

      if not keep then
        buffers[i] = true
      end
    end
  end

  for i, item in ipairs(state.components) do
    if buffers[i] then
      local id = item.id
      vim.schedule(function()
        vim.cmd(string.format("bdelete! %d", id))
        bufferline_ui.refresh()
      end)
    end
  end
end

local function get_element(state, id)
  for _, item in ipairs(state.components) do
    local element = item:as_element()
    if element and element.id == id then
      return element
    end
  end

  return nil
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "nvim-tree/nvim-web-devicons",
}

M.config = function()
  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      mode = "buffers",
      middle_mouse_command = function(id)
        local bufferline_ui = require("bufferline.ui")
        local state = require("bufferline.state")
        local groups = require("bufferline.groups")
        local element = get_element(state, id)
        if element == nil then
          return
        end

        if groups._is_pinned(element) then
          groups.remove_element("pinned", element)
        else
          groups.add_element("pinned", element)
        end

        bufferline_ui.refresh()
      end,
      tab_size = 24,
      max_name_length = 24,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, _diagnostics, _context)
        local sign = signs[level]
        if sign == nil then
          return ""
        end

        return " " .. sign .. " " .. count
      end,
    },
  })

  command("BufferLineCloseNotPinned", function(opts)
    close_not_pinned()
  end, {})

  autocmd("BufWritePre", {
    group = augroup("BufferLineAutoPin", { clear = true }),
    desc = "Auto pin buffer in BufferLine",
    callback = function(e)
      local bufferline_ui = require("bufferline.ui")
      local state = require("bufferline.state")
      local groups = require("bufferline.groups")
      local element = get_element(state, e.buf)
      if element == nil then
        return
      end

      if not groups._is_pinned(element) then
        groups.add_element("pinned", element)
      end

      bufferline_ui.refresh()
    end,
  })

  autocmd("BufWinLeave", {
    group = augroup("BufferLineAutoCloseNotPinned", { clear = true }),
    desc = "Auto close not pinned buffers in BufferLine",
    callback = function(e)
      vim.schedule(function()
        local bufferline_ui = require("bufferline.ui")
        local state = require("bufferline.state")
        local groups = require("bufferline.groups")
        local element = get_element(state, e.buf)
        if element == nil then
          return
        end

        local current_buffer = vim.api.nvim_get_current_buf()
        local keep = element.id == current_buffer
          or element.modified
          or groups._is_pinned(element)
        if keep then
          return
        end

        local id = element.id
        vim.schedule(function()
          vim.cmd(string.format("bdelete! %d", id))
          bufferline_ui.refresh()
        end)
      end)
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
