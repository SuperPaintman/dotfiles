--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local utils = require("utils.utils")

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.utils", function()
  describe("concat()", function()
    it("should work", function()
      local got = utils.concat({ 1, 2, 3 }, { "a", "b", "c" })

      assert.same(got, { 1, 2, 3, "a", "b", "c" })
    end)

    it("should not modify the parameters", function()
      local a = { 1, 2, 3 }
      local b = { "a", "b", "c" }
      local got = utils.concat(a, b)

      assert.same(got, { 1, 2, 3, "a", "b", "c" })
      assert.same(a, { 1, 2, 3 })
      assert.same(b, { "a", "b", "c" })
    end)
  end)

  describe("uniq()", function()
    it("should work", function()
      local got = utils.uniq({ 1, 8, 9, 1, 10, 81, 8 })

      assert.same(got, { 1, 8, 9, 10, 81 })
    end)

    it("should not modify the parameters", function()
      local a = { 1, 8, 9, 1, 10, 81, 8 }
      local got = utils.uniq(a)

      assert.same(got, { 1, 8, 9, 10, 81 })
      assert.same(a, { 1, 8, 9, 1, 10, 81, 8 })
    end)
  end)

  describe("once()", function()
    it("should work", function()
      local f = utils.once(function() return 1337 end)

      local got = f()

      assert.same(got, 1337)
    end)

    it("should support functions with multiple return values", function()
      local f0 = utils.once(function() end)
      local f1 = utils.once(function() return 10 end)
      local f2 = utils.once(function() return 10, 20 end)
      local f3 = utils.once(function() return 10, 20, 30 end)

      local got0 = { f0() }
      local got1 = { f1() }
      local got2 = { f2() }
      local got3 = { f3() }

      assert.same(got0, {})
      assert.same(got1, { 10 })
      assert.same(got2, { 10, 20 })
      assert.same(got3, { 10, 20, 30 })
    end)

    it("should call the funciton only once", function()
      local called = 0
      local f = utils.once(function()
        called = called + 1
      end)

      f()
      f()
      f()

      assert.same(called, 1)
    end)

    it("should re-throw errors", function()
      local called = 0
      local f = utils.once(function()
        called = called + 1
        error("boom")
      end)

      assert.has_error(f)
      assert.has_error(f)
      assert.has_error(f)

      assert.same(called, 1)
    end)
  end)

  describe("debounce()", function()
    it("should work", function()
      local called = 0
      local f = utils.debounce(function()
        called = called + 1
      end, 100)

      f()

      vim.wait(1000, function() return called == 1 end, 50)

      assert.same(called, 1)
    end)

    it("should pass last args", function()
      local called = 0
      local last_args = nil
      local f = utils.debounce(function(...)
        called = called + 1
        last_args = { ... }
      end, 100)

      f(10, 20, 30)
      f(100, 200, 300)
      f(1000, 2000, 3000)

      vim.wait(1000, function() return called == 1 end, 50)

      assert.same(called, 1)
      assert.same(last_args, { 1000, 2000, 3000 })
    end)

    it("should allow to call function again after timeout", function()
      local called = 0
      local last_args = nil
      local f = utils.debounce(function(...)
        called = called + 1
        last_args = { ... }
      end, 100)

      f(100)

      vim.wait(1000, function() return called == 1 end, 50)

      f(200)

      vim.wait(1000, function() return called == 2 end, 50)

      assert.same(called, 2)
      assert.same(last_args, { 200 })
    end)

    describe("cancel()", function()
      it("should work", function()
        local called = 0
        local f, cancel = utils.debounce(function()
          called = called + 1
        end, 100)

        f()

        cancel()

        vim.wait(200)

        assert.same(called, 0)
      end)

      it("should allow to call function again after cancel", function()
        local called = 0
        local last_args = nil
        local f, cancel = utils.debounce(function(...)
          called = called + 1
          last_args = { ... }
        end, 100)

        f(100)

        cancel()

        f(200)

        vim.wait(1000, function() return called == 1 end, 50)

        assert.same(called, 1)
        assert.same(last_args, { 200 })
      end)
    end)
  end)

  describe("is_callable()", function()
    it("should work", function()
      local got = utils.is_callable(function() end)

      assert.same(got, true)
    end)

    for _, tc in ipairs({
      { "function",  function() end,                                true },
      { "mt.__call", setmetatable({}, { __call = function() end }), true },
      { "nil",       nil,                                           false },
      { "boolean",   nil,                                           false },
      { "integer",   100,                                           false },
      { "string",    "test",                                        false },
      { "table",     { a = 10 },                                    false },
      { "array",     { 10, 20, 30 },                                false },
      { "mt",        setmetatable({}, {}),                          false },
    }) do
      local msg = ("should return `%s` for %s"):format(tc[3], tc[1])
      it(msg, function()
        local got = utils.is_callable(tc[2])
        local want = tc[3]

        assert.same(got, want)
      end)
    end

    it("should work", function()
      local got = utils.is_callable(function() end)

      assert.same(got, true)
    end)
  end)

  describe("lazy()", function()
    it("should work", function()
      local initialized = 0
      local called = 0
      local f = utils.lazy(function()
        initialized = initialized + 1

        ---@generic T
        ---@param a T
        ---@return T
        return function(a)
          called = called + 1
          return a
        end
      end)

      assert.same(initialized, 0)

      local got = f(100)

      assert.same(initialized, 1)
      assert.same(called, 1)
      assert.same(got, 100)
    end)

    it("should initialize value only once", function()
      local initialized = 0
      local called = 0
      local f = utils.lazy(function()
        initialized = initialized + 1

        ---@generic T
        ---@param a T
        ---@return T
        return function(a)
          called = called + 1
          return a
        end
      end)

      assert.same(initialized, 0)

      f(1)
      f(2)
      f(3)
      local got = f(400)

      assert.same(initialized, 1)
      assert.same(called, 4)
      assert.same(got, 400)
    end)

    it("should be initialized when the field is accessed", function()
      local initialized = 0
      local t = utils.lazy(function()
        initialized = initialized + 1
        return { a = 100 }
      end)

      assert.same(initialized, 0)

      local got

      got = t.a
      assert.same(initialized, 1)
      assert.same(got, 100)

      got = t.a
      assert.same(initialized, 1)
      assert.same(got, 100)
    end)

    it("should be initialized when the field is assigned", function()
      local initialized = 0
      local t = utils.lazy(function()
        initialized = initialized + 1
        return { a = 100 }
      end)

      assert.same(initialized, 0)

      t.a = 200
      assert.same(initialized, 1)

      t.a = 300
      assert.same(initialized, 1)

      assert.same(t.a, 300)
    end)

    describe(":__tostring()", function()
      it("should work", function()
        local f = utils.lazy(function()
          return function() end
        end)

        assert.same("Lazy(unknown)", tostring(f))

        f()

        assert.same("Lazy(function)", tostring(f))
      end)
    end)
  end)
end)
