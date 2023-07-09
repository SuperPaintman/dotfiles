-- See: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.setup = function()
  local ls = require("luasnip")
  local extras = require("luasnip.extras")
  local fmta = require("luasnip.extras.fmt").fmta
  local postfix = require("luasnip.extras.postfix").postfix

  local sn = ls.snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local d = ls.dynamic_node
  local rep = extras.rep

  ls.add_snippets("go", {
    -- Postfix-based snippets.
    postfix("?", {
      d(1, function(_, parent)
        local pm = parent.snippet.env.POSTFIX_MATCH

        local nodes = {}
        if pm == nil or pm == "" then
          nodes["err"] = i(1, "err")
          nodes["err_return"] = rep(1)
        else
          nodes["err"] = t(pm)
          nodes["err_return"] = t(pm)
        end

        return sn(
          nil,
          fmta(
            [[
              if <err> != nil {
                return <err_return>
              }
            ]],
            nodes
          )
        )
      end),
    }),

    postfix(".append!", {
      d(1, function(_, parent)
        local pm = parent.snippet.env.POSTFIX_MATCH

        local nodes = {}
        if pm == nil or pm == "" then
          nodes["slice"] = i(1, "slice")
          nodes["slice_same"] = rep(1)
          nodes["element"] = i(2)
        else
          nodes["slice"] = t(pm)
          nodes["slice_same"] = t(pm)
          nodes["element"] = i(1)
        end

        return sn(
          nil,
          fmta(
            [[
              <slice> = append(<slice_same>, <element>)
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
