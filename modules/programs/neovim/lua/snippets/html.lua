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
  local fmt = require("luasnip.extras.fmt").fmt

  local s = ls.snippet
  local i = ls.insert_node

  ls.add_snippets("html", {
    s(
      "!",
      fmt(
        [[
          <!DOCTYPE html>
          <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <meta name="viewport" content="width={width}, initial-scale={scale}">
              <title>{title}</title>
            </head>
            <body>
              {}
            </body>
          </html>
        ]],
        {
          width = i(1, "device-width"),
          scale = i(2, "1.0"),
          title = i(3, "Document"),
          i(4),
        }
      ),
      {}
    ),
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
