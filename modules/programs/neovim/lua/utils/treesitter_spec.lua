--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local treesitter = require("utils.treesitter")

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.treesitter", function()
  describe("lazy_query_parse()", function()
    it("should work", function()
      assert.has_no.errors(function()
        local get_query = treesitter.lazy_query_parse(
          "lua",
          [[
            (comment) @target
          ]]
        )

        local _ = get_query()
      end)
    end)

    it("should return a TS query", function()
      local get_query = treesitter.lazy_query_parse(
        "lua",
        [[
          (comment) @target
        ]]
      )

      local query = get_query() --[[@as Query]]

      assert.is_not_nil(query)
      assert.same(query.captures, { "target" })
      assert.same(type(query.iter_captures), "function")
    end)
  end)
end)
