-- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function func_snippet(name, signature)
  local ls = require("luasnip")
  local fmt = require("luasnip.extras.fmt").fmt

  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node

  return s(
    "func " .. name,
    fmt(
      [[
        func {name}{signature}:
        {tab}{}
      ]],
      {
        tab = t("\t"),
        name = t(name),
        signature = t(signature),
        i(1, "pass"),
      }
    )
  )
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.setup = function()
  local ls = require("luasnip")
  local fmt = require("luasnip.extras.fmt").fmt
  local postfix = require("luasnip.extras.postfix").postfix

  local s = ls.snippet
  local sn = ls.snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local d = ls.dynamic_node

  ls.add_snippets("gdscript", {
    -- Basic functions.
    func_snippet("_ready", "() -> void"),
    func_snippet("_enter_tree", "() -> void"),
    func_snippet("_exit_tree", "() -> void"),
    func_snippet("_process", "(delta: float) -> void"),
    func_snippet("_physics_process", "(delta: float) -> void"),
    func_snippet("_input", "(event: InputEvent) -> void"),
    func_snippet("_to_string", "() -> String"),

    -- Class.
    s(
      "class",
      fmt(
        [[
          class {name} extends {base}:
          {tab}{}
        ]],
        {
          tab = t("\t"),
          name = i(1, "Class"),
          base = i(2, "RefCounted"),
          i(3, "pass"),
        }
      )
    ),

    -- Var with getter/setter
    s(
      "vargs",
      fmt(
        [[
          var {name}: {type} = {default}:
          {tab}get:
          {tab}{tab}return {name}
          {tab}set(v):
          {tab}{tab}{name} = v
        ]],
        {
          tab = t("\t"),
          name = i(1, "name"),
          type = i(2, "int"),
          default = i(3, "0"),
        },
        {
          repeat_duplicates = true,
        }
      )
    ),

    -- Postfix-based snippets.
    postfix(".dbg!", {
      d(1, function(_, parent)
        local pm = parent.snippet.env.POSTFIX_MATCH

        local nodes = {}
        if pm == nil or pm == "" then
          nodes["expr"] = i(1, "name")
        else
          nodes["expr"] = t(pm)
        end

        return sn(
          nil,
          fmt(
            [[
              print_debug("{expr} = ", {expr})
            ]],
            nodes
          )
        )
      end),
    }),
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
