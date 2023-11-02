--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "nvim-tree/nvim-web-devicons",
}

M.config = function()
  local api = require("nvim-tree.api")

  require("nvim-tree").setup({
    filters = {
      custom = { "^\\.git$" },
    },
    disable_netrw = true,
    sync_root_with_cwd = true,
    view = {
      width = 40,
      preserve_window_proportions = true,
    },
    renderer = {
      -- Hide the root folder label.
      root_folder_label = false,

      icons = {
        git_placement = "after",

        -- TODO(SuperPaintman):
        --     Add custom icons, and put them into a global config file.
        glyphs = {
          git = {
            unstaged = "●",
            staged = "●",
            unmerged = "●",
            renamed = "●",
            untracked = "●",
            deleted = "●",
            ignored = "●",
          },
        },
      },

      special_files = {},
    },
    on_attach = function(bufnr)
      -- Init
      local set = vim.keymap.set

      -- Helpers.
      local function opts(o)
        return vim.tbl_extend("force", {
          buffer = bufnr,
          silent = true,
          nowait = true,
        }, o)
      end

      -- Add default mappings.
      api.config.mappings.default_on_attach(bufnr)

      -- Add custom mappings.
      set(
        "n",
        "?",
        api.tree.toggle_help,
        opts({
          desc = "nvim-tree: Help",
        })
      )
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
