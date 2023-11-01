-- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- See: https://github.com/ray-x/go.nvim/blob/master/lua/go/snips.lua
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local conditions = require("luasnip.extras.conditions")
local conditions_expand = require("luasnip.extras.conditions.expand")

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias snippets.conditions.Condition fun(line_to_cursor: string, matched_trigger?: string, captures?: table): boolean

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

---@type fun(snippets.conditions.Condition): snippets.conditions.Condition
local make_condition = conditions.make_condition

---@type unknown
local line_begin = conditions_expand.line_begin

---@type unknown
local line_end = conditions_expand.line_end

---@type unknown
local has_selected_text = conditions_expand.has_selected_text

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.make_condition = make_condition

---@param check string|string[]|fun(TSNode): boolean
---@param rec boolean?
---@return snippets.conditions.Condition
M.make_in_ts_node = function(check, rec)
  if rec == nil then
    rec = true
  end

  if type(check) == "string" then
    local kind = check
    check = function(node)
      return node:type() == kind
    end
  elseif type(check) == "table" then
    local kinds = check
    check = function(node)
      local k = node:type()
      for _, kind in ipairs(kinds) do
        if k == kind then
          return true
        end
      end
      return false
    end
  end

  return make_condition(function()
    -- A patched version of ts_utils.get_node_at_cursor() that supports
    -- insert mode.

    local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
    if not ok then
      return false
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    if vim.api.nvim_get_mode().mode == "i" then
      col = col - 1
    end

    local buf = vim.api.nvim_win_get_buf(0)
    local root_lang_tree = ts_parsers.get_parser(buf)
    if not root_lang_tree then
      return false
    end

    -- Ignore injected langs.
    ---@type TSNode|nil
    local root = nil
    for _, tree in ipairs(root_lang_tree:trees()) do
      local tree_root = tree:root()
      if tree_root and vim.treesitter.is_in_node_range(tree_root, row, col) then
        root = tree_root
        break
      end
    end

    if not root then
      return false
    end

    local node = root:named_descendant_for_range(row, col, row, col)
    if rec then
      while node ~= nil do
        if check(node) then
          return true
        end
        node = node:parent()
      end
    else
      if check(node) then
        return true
      end
    end

    return false
  end)
end

---@type snippets.conditions.Condition
M.line_begin = line_begin

---@type snippets.conditions.Condition
M.line_end = line_end

---@type snippets.conditions.Condition
M.has_selected_text = has_selected_text

-- Note:
--     lua= require("nvim-treesitter.ts_utils").get_node_under_cursor():type()

-- All.
M.in_comment = M.make_in_ts_node("comment")

-- GDScript.

-- Go.
M.in_go_top_level = M.make_in_ts_node("source_file", false)

M.in_go_function =
  M.make_in_ts_node({ "function_declaration", "method_declaration" })

-- Lua.
M.in_lua_top_level = M.make_in_ts_node("chunk", false)

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
