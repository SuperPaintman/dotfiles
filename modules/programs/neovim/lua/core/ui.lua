--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
---@class core.ui.Module
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.icons = {
  common = {
    Collapsed = "",
    Expanded = "",
  },

  cmp = {
    Namespace = "󰌗",
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰆧",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈚",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Table = "",
    Object = "󰅩",
    Tag = "",
    Array = "",
    Boolean = "",
    Number = "",
    Null = "󰟢",
    String = "󰉿",
    Calendar = "",
    Watch = "󰥔",
    Package = "",
    Copilot = "",
    Codeium = "",
    TabNine = "",
  },

  diagnostic = {
    Error = "",
    Warn = "",
    Info = "",
    Hint = "",
    Ok = "󰄳",
    Virtual = "󱓻",
  },

  debugger = {
    Breakpoint = "",
    BreakpointCondition = "",
    BreakpointRejected = "",
    Logpoint = "",
    Stopped = "",
  },
}

M.borders = {
  thick = function(hl_name)
    if hl_name == nil then
      hl_name = "VertSplit"
    end

    return {
      { "▄", hl_name },
      { "▄", hl_name },
      { "▄", hl_name },
      { "█", hl_name },
      { "▀", hl_name },
      { "▀", hl_name },
      { "▀", hl_name },
      { "█", hl_name },
    }
  end,
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
