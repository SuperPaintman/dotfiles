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
-- Pickers
--------------------------------------------------------------------------------
---@param opts table?
local function marks_picker(opts)
  opts = opts or {}

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local config = require("telescope.config").values
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")
  local marks = require("modules.marks")

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 2 },
      { remaining = true },
    },
  })

  ---@param entry table
  local function display(entry)
    local item = entry.value
    local bufname = vim.fn.fnamemodify(item.file or "[No Name]", ":~:.")
    return displayer({
      { item.name, "TelescopeResultsFunction" },
      string.format("%s:%d", bufname, item.lnum),
      -- { tostring(item.lnum), "TelescopeResultsNumber" },
    })
  end

  ---@param item modules.marks.Entry
  local function entry_maker(item)
    return {
      value = item,
      ordinal = item.name .. " " .. (item.file or ""),
      display = display,
      filename = item.file,
      lnum = item.lnum,
      col = item.col + 1,
    }
  end

  local function finder()
    return finders.new_table({
      results = marks.list(),
      entry_maker = entry_maker,
    })
  end

  pickers
      .new(opts, {
        prompt_title = "Marks",
        finder = finder(),
        sorter = config.generic_sorter(opts),
        previewer = config.qflist_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local entry = actions_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if entry ~= nil then
              marks.jump(entry.value.name, false)
            end
          end)

          map({ "i", "n" }, "<C-d>", function()
            local entry = actions_state.get_selected_entry()
            if entry ~= nil then
              marks.delete(entry.value.name)
              actions_state
                  .get_current_picker(prompt_bufnr)
                  :refresh(finder(), { reset_prompt = false })
            end
          end)

          return true
        end,
      })
      :find()
end

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

  telescope.register_extension({
    exports = { better_marks = marks_picker },
  })
  telescope.extensions.better_marks = { better_marks = marks_picker }

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

  find_marks = cb(function()
    -- require("telescope.builtin").marks()
    marks_picker()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
