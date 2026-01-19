--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local palette = require("theme.palette")
local colors = require("utils.colors")

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
---@field link? string

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

---@param group string
local function unset(group)
  h(group, {})
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

  -- h("VertSplit", { fg = palette.colors.base2 })
  h("VertSplit", { fg = palette.colors.base1, bg = palette.colors.base2 }) -- Looks better with other dark windows.
  h("UIBorders", { fg = palette.colors.base2 })
  l("UIBordersThick", "UIBorders")

  h("Pmenu", { bg = palette.colors.base2 })
  h("PmenuSel", { bg = palette.colors.base4 })
  h("PmenuSbar", { bg = palette.colors.base2 })
  h("PmenuThumb", { bg = palette.colors.base5 })

  h("Folded", {
    fg = palette.colors.base5,
    bg = colors.mix(palette.colors.base2, palette.colors.base3, 0.5),
  })

  -- Diff
  h("DiffAdd", {
    fg = palette.colors.green,
    bg = colors.mix(palette.colors.background, palette.colors.green, 0.15),
  })
  h("DiffChange", {
    fg = palette.colors.yellow,
    bg = colors.mix(palette.colors.background, palette.colors.yellow, 0.15),
  })
  h("DiffText", {
    fg = palette.colors.yellow,
    bg = colors.mix(palette.colors.background, palette.colors.yellow, 0.3),
  })
  h("DiffDelete", {
    fg = palette.colors.red,
    bg = colors.mix(palette.colors.background, palette.colors.red, 0.15),
  })

  -- Quick Fix.
  h("qfFileName", { fg = palette.colors.yellow })
  h("qfLineNr", { fg = palette.colors.magenta })

  -- Diagnostic
  h("DiagnosticVirtualTextError", {
    fg = palette.colors.darkRed,
    bg = colors.mix(palette.colors.background, palette.colors.darkRed, 0.15),
  })

  h("DiagnosticVirtualTextWarn", {
    fg = palette.colors.darkYellow,
    bg = colors.mix(palette.colors.background, palette.colors.darkYellow, 0.15),
  })

  h("DiagnosticVirtualTextInfo", {
    fg = palette.colors.foreground,
    bg = colors.mix(palette.colors.background, palette.colors.foreground, 0.15),
  })

  h("DiagnosticVirtualTextHint", {
    fg = palette.colors.blue,
    bg = colors.mix(palette.colors.background, palette.colors.blue, 0.15),
  })

  -- Sytax
  --- Comment.
  h("Comment", { fg = palette.colors.base6 })

  --- Constant.
  h("Constant", { fg = palette.colors.violet })
  h("String", { fg = palette.colors.green })
  h("Character", { fg = palette.colors.green })

  -- Operator.
  h("Operator", { fg = palette.colors.magenta })

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
  l("@markup.italic.markdown_inline", "markdownItalic")
  l("@markup.strong.markdown_inline", "markdownBold")
  h("@markup.list.markdown", { fg = palette.colors.magenta })
  -- h("@markup.list.checked.markdown", { fg = palette.colors.magenta }) -- TODO(Aleksandr Krivoshchekov): highligh only the marker.
  h("@markup.raw.markdown_inline", { fg = palette.colors.magenta })
  l("@markup.link.label.markdown_inline", "@text.uri.html")
  h("@markup.link.url.markdown_inline", { fg = palette.colors.violet })
  l("@markup.link.label.markdown", "@markup.link.label.markdown_inline")
  l("@markup.link.url.markdown", "@markup.link.url.markdown_inline")
  h("@markup.strikethrough.markdown_inline", { fg = palette.colors.yellow, strikethrough = true })

  ---- INI
  l("dosiniHeader", "configSection")
  l("dosiniLabel", "configKey")

  ---- TOML
  l("tomlTable", "configSection")
  l("tomlKey", "configKey")
  l("tomlKeyDq", "tomlKey")
  l("tomlKeySq", "tomlKey")

  ---- GDResource
  l("gdResourceSectionName", "configSection")
  l("gdResourceAttributeName", "configKey")

  ---- ZSH
  l("zshFunction", "Function")

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

  ---- Property.
  -- l("@property", "configKey")
  l("@property.json", "configKey")
  l("@property.yaml", "@property.json")

  ---- Field.
  l("@field.yaml", "configKey")

  ---- Text.
  h("@text.uri", { fg = palette.colors.violet, underline = true })

  ---- Type.
  l("@type.builtin", "@type")

  ---- Diff.
  h("@function.diff", { fg = palette.colors.magenta })
  h("@attribute.diff", { fg = palette.colors.violet })
  l("@text.diff.add", "DiffAdd")
  l("@text.diff.delete", "DiffDelete")
  h("@constant.diff", { fg = palette.colors.yellow })
  l("@text.diff.index", "Comment")

  -- Language Specific / Treesitter / LSP
  --- Rust
  l("@lsp.type.macro.rust", "@function.macro")
  l("@lsp.type.enumMember.rust", "Type")

  --- Terraform
  l("@lsp.type.type.terraform", "@keyword")
  l("@lsp.type.enumMember.terraform", "@string")

  --- JavaScript
  l("@preproc.javascript", "String")

  --- TypeScript
  l("@preproc.typescript", "String")
  l("@constructor.typescript", "Function")
  l("@type.qualifier.typescript", "@keyword")

  --- HTML
  h("@tag.html", { fg = palette.colors.red })
  h("@tag.attribute.html", { fg = palette.colors.yellow })
  l("@operator.html", "@text.html")
  h("@text.uri.html", { fg = palette.colors.green, underline = true })
  l("@text.title.html", "@text.html")
  l("@text.title.1.html", "@text.html")
  l("@text.title.2.html", "@text.html")
  l("@text.title.3.html", "@text.html")
  l("@text.title.4.html", "@text.html")
  l("@text.title.5.html", "@text.html")
  l("@text.title.6.html", "@text.html")
  l("@markup.heading.html", "@text.html")
  l("@markup.heading.1.html", "@text.html")
  l("@markup.heading.2.html", "@text.html")
  l("@markup.heading.3.html", "@text.html")
  l("@markup.heading.4.html", "@text.html")
  l("@markup.heading.5.html", "@text.html")
  l("@markup.heading.6.html", "@text.html")

  --- CSS
  h("@type.selector.css", { fg = palette.colors.red })
  l("@type.selector.tag.css", "@type.selector.css")
  l("@type.selector.id.css", "@type.selector.css")
  l("@type.selector.class.css", "@type.selector.css")
  h("@property.name.css", { fg = palette.colors.yellow })
  h("@constant.unit.css", { fg = palette.colors.red })
  unset("@property.css")
  unset("@punctuation.delimiter.css")

  --- Svelte
  l("@tag.svelte", "@tag.html")
  l("@tag.attribute.svelte", "@tag.attribute.html")
  l("@operator.svelte", "@text.svelte")
  l("@text.uri.svelte", "@text.uri.html")
  l("@text.title.svelte", "@text.title.html")
  l("@text.title.1.svelte", "@text.title.1.html")
  l("@text.title.2.svelte", "@text.title.2.html")
  l("@text.title.3.svelte", "@text.title.3.html")
  l("@text.title.4.svelte", "@text.title.4.html")
  l("@text.title.5.svelte", "@text.title.5.html")
  l("@text.title.6.svelte", "@text.title.6.html")
  l("@lsp.type.class.svelte", "@tag.svelte")

  --- TreeSitter Query
  l("@variable.query", "@type")
  l("@punctuation.special.query", "@keyword")
  l("@type.query", "Constant")
  -- l("@constant.query", "Constant")

  --- Zig
  l("@type.qualifier.zig", "@keyword") -- const, var, volatile, allowzero, noalias
  l("@attribute.zig", "@keyword")      -- comptime, export, extern, inline, noinline, packed, pub, threadlocal

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
  --- Telescope
  l("TelescopeNormal", "Pmenu")
  l("TelescopeSelection", "PmenuSel")
  l("TelescopeBorder", "Pmenu")
  h("TelescopeTitle", { bold = true })

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
  l("NeogitDiffAdd", "DiffAdd")
  h("NeogitDiffAddHighlight", {
    fg = palette.colors.green,
    bg = colors.mix(palette.colors.base4, palette.colors.green, 0.15),
  })
  l("NeogitDiffDelete", "DiffDelete")
  h("NeogitDiffDeleteHighlight", {
    fg = palette.colors.red,
    bg = colors.mix(palette.colors.base4, palette.colors.red, 0.15),
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
    Copilot = palette.colors.blue,
    Codeium = nil,
    TabNine = nil,
  }
  for kind, color in pairs(cmp_item_kinds) do
    if color ~= nil then
      h("CmpItemKind" .. kind, { fg = color })
    end
  end
  l("CmpDocNormal", "Pmenu")
  l("CmpDocBorder", "UIBorders")

  --- BufferLine
  l("BufferLineErrorSelected", "BufferLineBufferSelected")
  l("BufferLineErrorDiagnosticSelected", "DiagnosticSignError")
  l("BufferLineWarningSelected", "BufferLineBufferSelected")
  l("BufferLineWarningDiagnosticSelected", "DiagnosticSignWarn")

  --- LSP Saga
  l("SagaTitle", "Pmenu")
  l("SagaBorder", "UIBorders")
  l("SagaNormal", "Pmenu")
  l("RenameNormal", "Pmenu")

  --- Nvim DAP
  h("DapBreakpoint", { fg = palette.colors.red })
  l("DapBreakpointCondition", "DapBreakpoint")
  l("DapBreakpointRejected", "DapBreakpoint")
  l("DapLogPoint", "DapBreakpoint")
  h("DapStopped", {
    fg = palette.colors.red,
    bg = colors.mix(palette.colors.background, palette.colors.red, 0.15),
  })
  h("DapStoppedLine", {
    bg = colors.mix(palette.colors.background, palette.colors.red, 0.15),
  })
  h("DapStoppedLineNr", {
    fg = palette.colors.red,
    bg = colors.mix(palette.colors.background, palette.colors.red, 0.15),
  })

  h("DapUINormal", {
    fg = palette.colors.foreground,
    bg = palette.colors.base2,
  })
  l("DapUINormalNC", "DapUINormal")
  -- l("DapUIEndofBuffer", "DapUINormal")
  l("DapUIBreakpointsLine", "LineNr")
  h("DapUICurrentFrameName", {
    fg = palette.colors.foreground,
    bold = true,
  })
  h("DapUIValue", {
    fg = palette.colors.foreground,
  })
  h("DapUIModifiedValue", {
    fg = palette.colors.violet,
    bg = colors.mix(palette.colors.base2, palette.colors.violet, 0.15),
    bold = true,
  })

  h("DapUIDecoration", {
    fg = palette.colors.base5,
  })

  l("DapUIType", "Type")
  l("DapUISource", "Type")
  l("DapUILineNumber", "String")
  h("DapUIWatchesEmpty", {
    fg = palette.colors.red,
  })
  h("DapUIWatchesError", {
    fg = palette.colors.red,
  })
  h("DapUIWatchesValue", {
    fg = palette.colors.green,
  })

  h("DapUIScope", {
    fg = palette.colors.magenta,
    bold = true,
  })
  l("DapUIBreakpointsPath", "DapUIScope")
  l("DapUIStoppedThread", "DapUIScope")
  l("DapUIThread", "DapUIScope")

  h("DapUIPlayPause", {
    fg = palette.colors.green,
    bold = true,
  })
  h("DapUIStop", {
    fg = palette.colors.red,
    bold = true,
  })
  l("DapUIRestart", "DapUIPlayPause")
  l("DapUIStepOut", "DapUIPlayPause")
  l("DapUIStepBack", "DapUIPlayPause")
  l("DapUIStepInto", "DapUIPlayPause")
  l("DapUIStepOver", "DapUIPlayPause")

  l("DapUIPlayPauseNC", "DapUIPlayPause")
  l("DapUIRestartNC", "DapUIPlayPauseNC")
  l("DapUIStepBackNC", "DapUIPlayPauseNC")
  l("DapUIStepIntoNC", "DapUIPlayPauseNC")
  l("DapUIStepOutNC", "DapUIPlayPauseNC")
  l("DapUIStepOverNC", "DapUIPlayPauseNC")
  l("DapUIStopNC", "DapUIStop")

  h("NvimDapVirtualText", {
    fg = palette.colors.magenta,
    bg = colors.mix(palette.colors.background, palette.colors.magenta, 0.15),
  })

  -- Modules.
  --- ContextSigns.
  h("ContextSign", { fg = palette.colors.base8 })
end

M.reload = function()
  local unload = require("utils.modules").unload
  unload("theme.palette")

  palette = require("theme.palette")

  M.setup({
    clear = false,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
