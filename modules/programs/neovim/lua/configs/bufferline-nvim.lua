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

local M = {
  _initialized = false,
}

local cb = require("utils.mappings").create_callback_factory(
  M,
  "bufferline is not initialized"
)

local signs = {
  error = ui.icons.diagnostic.Error,
  warning = ui.icons.diagnostic.Warn,
}

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
      tab_size = 24,
      max_name_length = 24,
      show_buffer_close_icons = false,
      modified_icon = "●",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, _diagnostics, _context)
        local sign = signs[level]
        if sign == nil then
          return ""
        end

        return " " .. sign .. " " .. count
      end,
      offsets = {
        -- { filetype = "NvimTree", text = "", padding = 1 },
      },
    },
  })

  M._initialized = true
end

M.mappings = {
  pick = cb(function()
    require("bufferline").pick()
  end),

  close_with_pick = cb(function()
    require("bufferline").close_with_pick()
  end),

  close_others = cb(function()
    require("bufferline").close_others()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
