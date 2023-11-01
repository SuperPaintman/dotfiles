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

  -- Variables
  h("configSection", { fg = palette.colors.red })
  h("configKey", { fg = palette.colors.magenta })

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
  h("CursorLineNr", { fg = palette.colors.cursor, bold = true })

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

  --- Markup.
  h("Title", { fg = palette.colors.red })

  --- Languages
  ---- Markdown
  h("markdownBold", { fg = palette.colors.yellow, bold = true })
  h("markdownItalic", { fg = palette.colors.yellow, italic = true })
  h("markdownCode", { fg = palette.colors.magenta })
  h("markdownCodeDelimiter", { fg = palette.colors.magenta })
  h("markdownUrl", { fg = palette.colors.violet, underline = true })
  l("markdownListMarker", "Normal")
  l("markdownUrlDelimiter", "Normal")
  l("markdownLinkText", "String")
  l("markdownH1Delimiter", "Title")
  l("markdownH2Delimiter", "Title")
  l("markdownH3Delimiter", "Title")
  l("markdownH4Delimiter", "Title")
  l("markdownH5Delimiter", "Title")
  l("markdownH6Delimiter", "Title")
  l("markdownRule", "Comment")

  ---- INI
  l("dosiniHeader", "configSection")
  l("dosiniLabel", "configKey")

  ---- TOML
  l("tomlTable", "configSection")
  l("tomlKey", "configKey")

  ---- GDResource
  l("gdResourceSectionName", "configSection")
  l("gdResourceAttributeName", "configKey")

  --- Treesitter.
  ---- Constant.
  l("@constant", "Identifier")
  l("@constant.builtin", "Constant")

  ---- Constructor.
  l("@constructor.go", "Function")
  l("@constructor.gdscript", "Function")

  ---- Function.
  l("@function.call", "Function")
  l("@function.builtin", "Function")
  l("@function.macro", "Function")

  ---- Attribute.
  l("@attribute.gdscript", "Function")

  ---- Type Qalifier.
  l("@type.qualifier.gdscript", "@keyword")

  ---- Punctuation.
  h("@punctuation.special", { fg = palette.colors.violet })
  l("@punctuation.delimiter.accessor", "Operator")
  l("@punctuation.special.rust", "Operator")

  ---- String.
  h("@string.special", { fg = palette.colors.violet })
  h("@string.escape", { fg = palette.colors.violet })

  ---- Label.
  l("@label.json", "configKey")

  ---- Field.
  l("@field.yaml", "configKey")

  ---- Text.
  h("@text.uri", { fg = palette.colors.violet, underline = true })

  -- LSP
  --- Rust
  l("@lsp.type.macro.rust", "@function.macro")
  l("@lsp.type.enumMember.rust", "Type")

  -- Built-in Pluggins.
  --- Help
  l("helpSectionDelim", "markdownH1Delimiter")
  l("healthHeadingChar", "markdownRule")
  l("helpHeader", "markdownH2Delimiter")
  l("helpCommand", "markdownCode")

  --- Health
  h("healthSuccess", { fg = palette.colors.green, bold = true })
  h("healthWarning", { fg = palette.colors.yellow, bold = true })
  h("healthError", { fg = palette.colors.red, bold = true })

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

  --- NvimCmp
  h("CmpItemKind", { fg = palette.colors.white })
  local cmp_item_kinds = {
    Namespace = nil,
    Text = nil,
    Method = palette.colors.blue,
    Function = palette.colors.blue,
    Constructor = palette.colors.blue,
    Field = nil,
    Variable = nil,
    Class = palette.colors.yellow,
    Interface = palette.colors.yellow,
    Module = palette.colors.green,
    Property = nil,
    Unit = nil,
    Value = nil,
    Enum = palette.colors.violet,
    Keyword = palette.colors.magenta,
    Snippet = palette.colors.red,
    Color = nil,
    File = nil,
    Reference = nil,
    Folder = nil,
    EnumMember = palette.colors.violet,
    Constant = palette.colors.violet,
    Struct = palette.colors.yellow,
    Event = nil,
    Operator = nil,
    TypeParameter = nil,
    Table = nil,
    Object = nil,
    Tag = nil,
    Array = nil,
    Boolean = nil,
    Number = nil,
    Null = nil,
    String = nil,
    Calendar = nil,
    Watch = nil,
    Package = nil,
    Copilot = nil,
    Codeium = nil,
    TabNine = nil,
  }
  for kind, color in pairs(cmp_item_kinds) do
    if color ~= nil then
      h("CmpItemKind" .. kind, { fg = color })
    end
  end
  l("CmpDocNormal", "Pmenu")
  l("CmpDocBorder", "VertSplit")

  --- BufferLine
  l("BufferLineErrorSelected", "BufferLineBufferSelected")
  l("BufferLineErrorDiagnosticSelected", "DiagnosticSignError")
  l("BufferLineWarningSelected", "BufferLineBufferSelected")
  l("BufferLineWarningDiagnosticSelected", "DiagnosticSignWarn")

  -- Modules.
  --- ContextSigns.
  h("ContextSign", { fg = palette.colors.base8 })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
