--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local treesitter = require("utils.treesitter")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Go
--------------------------------------------------------------------------------
local go = {}
M.go = go

---@param winnr integer?
---@param options { top?: boolean }?
---@return TSNode?
function go.function_node_at_cursor(winnr, options)
  winnr = winnr or 0
  options = vim.tbl_deep_extend("force", {
    top = false,
  }, options or {})

  ---@type TSNode?
  local node = nil
  for n in treesitter.iter_scope_tree_at_cursor(winnr) do
    local typ = n:type()
    if not options.top and typ == "func_literal" then
      node = n
      break
    end

    if typ == "function_declaration" or typ == "method_declaration" then
      node = n
      break
    end
  end

  return node
end

local query_go_function_or_method_name = treesitter.lazy_query_parse(
  "go",
  [[
    [
      (function_declaration name: (_) @name)
      (method_declaration name: (_) @name)
    ]
  ]]
)

---@param winnr integer?
---@param options { top?: boolean }?
---@return string?
function go.function_name_at_cursor(winnr, options)
  local ts = treesitter.treesitter()
  if ts == nil then
    return nil
  end

  winnr = winnr or 0
  options = vim.tbl_deep_extend("force", {
    top = false,
  }, options or {})

  local node = go.function_node_at_cursor(winnr, {
    top = options.top,
  })
  if node == nil then
    return nil
  end

  if not options.top and node:type() == "func_literal" then
    return nil
  end

  local query = query_go_function_or_method_name()
  if query == nil then
    return nil
  end

  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local node_start, _, node_stop, _ = node:range()
  for i, n in query:iter_captures(node, winnr, node_start, node_stop + 1) do
    local capture = query.captures[i]
    if capture == "name" then
      local value = ts.get_node_text(n, bufnr)
      if value ~= nil then
        return value
      end
    end
  end

  return nil
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
