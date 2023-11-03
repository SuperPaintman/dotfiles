--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {
  _initialized = false,
}

local cb = require("utils.mappings").create_callback_factory(
  M,
  "telescope is not initialized"
)

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-treesitter/nvim-treesitter",
}

M.config = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      scroll_strategy = "cycle",

      prompt_prefix = " ",
      selection_caret = "▍ ",
      entry_prefix = "  ",
      multi_icon = " ",

      border = true,
      borderchars = { " " },

      color_devicons = true,

      preview = {
        treesitter = {
          go = true,
          lua = true,
        },
      },

      layout_config = {
        horizontal = {
          width = 0.6,
          preview_width = 0.6,
        },
      },

      mappings = {
        i = {
          ["<Esc>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-h>"] = actions.cycle_history_next,
          ["<C-l>"] = actions.cycle_history_prev,
          ["<C-d>"] = false, -- TODO(SuperPaintman): use it for page scrolling.
          ["<C-u>"] = false, -- TODO(SuperPaintman): use it for page scrolling.
          ["<C-p>"] = false,
          ["<C-n>"] = false,
        },
      },
    },
  })

  autocmd("User", {
    group = augroup("ConfigsTelescopePreviewerLoaded", { clear = true }),
    pattern = "TelescopePreviewerLoaded",
    callback = function()
      -- Print the line number in front of each line.
      vim.wo.number = true
    end,
  })

  M._initialized = true
end

M.mappings = {
  find_buffers = cb(function()
    require("telescope.builtin").buffers()
  end),

  find_files = cb(function()
    require("telescope.builtin").find_files()
  end),

  find_words = cb(function()
    require("telescope.builtin").live_grep()
  end),

  find_help_tags = cb(function()
    require("telescope.builtin").help_tags()
  end),

  find_recent_files = cb(function()
    require("telescope.builtin").oldfiles()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
