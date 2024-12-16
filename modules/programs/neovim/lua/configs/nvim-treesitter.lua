--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local buffers = require("utils.buffers")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local set = vim.keymap.set

local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@param size number
---@return string
local function human_readable_size(size)
  return math.floor(size / 1024) .. " KiB"
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "nvim-treesitter/nvim-treesitter-textobjects",
}

M.config = function()
  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local max_size = 256 * 1024 -- 256 KiB

        local size, ok = buffers.file_size(bufnr)
        if ok and size > max_size then
          vim.api.nvim_notify(
            "Disable Treesitter highlight, file is too large: "
              .. human_readable_size(size)
              .. " > "
              .. human_readable_size(max_size),
            vim.log.levels.WARN,
            {}
          )
          return true
        end

        return false -- TODO(SuperPaintman): check non-file buffers as well.
      end,
    },
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = {
            query = "@parameter.outer",
            desc = "an argument (@parameter.outer)",
          },
          ["ia"] = {
            query = "@parameter.inner",
            desc = "inner argument (@parameter.inner)",
          },
          ["af"] = {
            query = "@function.outer",
            desc = "a function (@function.outer)",
          },
          ["if"] = {
            query = "@function.inner",
            desc = "inner function (@function.inner)",
          },
        },
        include_surrounding_whitespace = false,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]a"] = {
            query = "@parameter.inner",
            desc = "Next argument (@parameter.inner)",
          },
        },
        goto_previous_start = {
          ["[a"] = {
            query = "@parameter.inner",
            desc = "Previous argument (@parameter.inner)",
          },
        },
      },
    },
  })

  -- Repeat movement with ; and ,
  set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
  set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
  set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
  set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
  set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
