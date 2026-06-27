-- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function get_git_name()
  local output = nil ---@type string|nil
  for _, field in ipairs({ "github.user", "user.name" }) do
    local ok, o = pcall(vim.fn.system, { "git", "config", "--get", field })
    if ok then
      output = o
      break
    end
  end

  if not output then
    return nil
  end

  local lines = vim.split(output, "\n")
  if #lines < 1 then
    return nil
  end

  local name = vim.trim(lines[1])
  if #name == 0 then
    return nil
  end

  return name
end

local function todo_snippet(tag)
  local ls = require("luasnip")
  local conditions = require("snippets.conditions")

  local s = ls.snippet
  local sn = ls.snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local d = ls.dynamic_node

  return s(tag, {
    t(tag .. "("),
    d(1, function()
      local name = get_git_name()

      local nodes = {}
      if name == nil then
        table.insert(nodes, i(1, "name"))
      else
        table.insert(nodes, t(name))
      end

      return sn(nil, nodes)
    end),
    t("): "),
  }, {
    condition = conditions.in_comment,
    show_condition = conditions.in_comment,
  })
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.setup = function()
  local ls = require("luasnip")

  ls.add_snippets("all", {
    -- TODO-like comments.
    todo_snippet("TODO"),
    todo_snippet("NOTE"),
    todo_snippet("FIX"),
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
