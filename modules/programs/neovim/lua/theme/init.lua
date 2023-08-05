--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local palette = require("theme.palette")

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@class theme.palette.HOpts
---@field bg? string
---@field fg? string
---@field link? string
---@field default? boolean
---@field bold? boolean
---@field italic? boolean
---@field underline? boolean

---@class theme.palette.LOpts
---@field default? boolean

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param group string
---@param opts? theme.palette.HOpts
local function h(group, opts)
  opts = vim.tbl_extend("force", {
    default = false,
  }, opts or {})

  vim.api.nvim_set_hl(0, group, opts)
end

---@param group string
---@param link string
---@param opts? theme.palette.LOpts
local function l(group, link, opts)
  opts = opts or {}
  opts.link = link

  ---@cast opts table
  h(group, opts)
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.setup = function(opts)
  opts = vim.tbl_extend("force", {
    clear = true,
  }, opts or {})

  if opts.clear and vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "theme"

  -- General
  h("Normal", {
    fg = palette.colors.foreground,
    bg = palette.colors.background,
  })

  --- Normal text in non-current windows.
  h("NormalNB", {
    fg = palette.colors.foreground,
    bg = palette.colors.background,
  })

  h("NonText", { fg = palette.colors.base4 }) -- Special characters.

  h("CursorLine", { bg = palette.colors.base4 })
  h("ColorColumn", { bg = palette.colors.base4 })

  h("Search", { bg = palette.colors.base5 })
  h("CurSearch", { bg = palette.colors.base5 })

  h("Visual", { bg = palette.colors.base5 })
  h("VisualNOS", { bg = palette.colors.base5 })

  h("SignColumn", { bg = palette.colors.background })

  h("LineNr", { fg = palette.colors.base5 })
  h("CursorLineNr", { fg = palette.colors.cursor })

  h("VertSplit", { fg = palette.colors.base2 })

  h("Pmenu", { bg = palette.colors.base2 })
  h("PmenuSel", { bg = palette.colors.base4 })
  h("PmenuSbar", { bg = palette.colors.base2 })
  h("PmenuThumb", { bg = palette.colors.base5 })

  -- Diff
  h("DiffAdd", { fg = palette.colors.green })
  h("DiffChange", { fg = palette.colors.yellow })
  h("DiffDelete", { fg = palette.colors.red })

  -- Sytax
  --- Comment.
  h("Comment", { fg = palette.colors.base6 })

  --- Constant.
  h("Constant", { fg = palette.colors.violet })
  h("String", { fg = palette.colors.green })
  h("Character", { fg = palette.colors.green })

  --- Identifier.
  h("Identifier", { fg = palette.colors.foreground })
  h("Function", { fg = palette.colors.blue })

  --- Statement.
  h("Statement", { fg = palette.colors.magenta })
  h("PreProc", { fg = palette.colors.magenta })

  --- Type.
  h("Type", { fg = palette.colors.yellow })

  --- Special.
  h("Special", { fg = palette.colors.foreground })

  --- Treesitter.
  ---- Constant.
  l("@constant", "Identifier")
  l("@constant.builtin", "Constant")

  ---- Constructor.
  l("@constructor.go", "Function")

  ---- Function.
  l("@function.call", "Function")
  l("@function.builtin", "Function")

  ---- Punctuation.
  h("@punctuation.special", { fg = palette.colors.violet })
  l("@punctuation.delimiter.accessor", "Operator")

  ---- String.
  h("@string.special", { fg = palette.colors.violet })
  h("@string.escape", { fg = palette.colors.violet })

  -- Plugins.
  --- Gitsigns
  h("GitSignsAdd", { fg = palette.colors.green })
  h("GitSignsChange", { fg = palette.colors.yellow })
  h("GitSignsDelete", { fg = palette.colors.red })
  l("GitSignsAddPreview", "DiffAdd")
  l("GitSignsDeletePreview", "DiffDelete")

  --- Neogit
  h("NeogitBranch", { fg = palette.colors.green })
  h("NeogitRemote", { fg = palette.colors.red })
  h("NeogitObjectId", { fg = palette.colors.yellow })
  h("NeogitHunkHeader", { fg = palette.colors.violet })
  h("NeogitHunkHeaderHighlight", { fg = palette.colors.violet })
  h("NeogitDiffContext", { bg = palette.colors.background })
  h("NeogitDiffContextHighlight", { bg = palette.colors.base4 })
  h("NeogitDiffAdd", { fg = palette.colors.green })
  h("NeogitDiffAddHighlight", {
    fg = palette.colors.green,
    bg = palette.colors.base4,
  })
  h("NeogitDiffDelete", { fg = palette.colors.red })
  h("NeogitDiffDeleteHighlight", {
    fg = palette.colors.red,
    bg = palette.colors.base4,
  })
  h("NeogitNotificationInfo", { fg = palette.colors.green })
  h("NeogitNotificationWarning", { fg = palette.colors.yellow })
  h("NeogitNotificationError", { fg = palette.colors.red })

  --- NvimTree
  h("NvimTreeNormal", {
    fg = palette.colors.foreground,
    bg = palette.colors.base2,
  })
  h("NvimTreeFolderName", { fg = palette.colors.foreground })
  h("NvimTreeFolderIcon", { fg = palette.colors.foreground })
  h("NvimTreeOpenedFolderName", { fg = palette.colors.foreground })
  h("NvimTreeEmptyFolderName", { fg = palette.colors.foreground })
  h("NvimTreeWinSeparator", {
    fg = palette.colors.base2,
    bg = palette.colors.base2,
  })
  h("NvimTreeSymlink", { fg = palette.colors.violet })
  h("NvimTreeExecFile", { fg = palette.colors.green })
  l("NvimTreeGitNew", "GitSignsAdd")
  l("NvimTreeGitDirty", "GitSignsChange")
  l("NvimTreeGitDeleted", "GitSignsDelete")
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
