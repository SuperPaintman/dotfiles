--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local languages = require("utils.languages")

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.languages", function()
  local prevwinnr = nil
  local testbufnr = nil
  local testwinnr = nil
  before_each(function()
    prevwinnr = vim.api.nvim_get_current_win()

    testbufnr = vim.api.nvim_create_buf(false, false)
    assert.is_not_nil(testbufnr)

    -- vim.api.nvim_buf_set_name(testbufnr, "")
    -- vim.api.nvim_set_option_value("filetype", lang, { buf = testbufnr })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = testbufnr })
    vim.api.nvim_set_option_value("swapfile", false, { buf = testbufnr })
    vim.api.nvim_set_option_value("buflisted", false, { buf = testbufnr })

    vim.api.nvim_open_win(testbufnr, true, {
      relative = "win",
      row = 3,
      col = 3,
      width = 12,
      height = 3,
    })
    testwinnr = vim.api.nvim_get_current_win()
    assert.is_not_nil(testwinnr)
    vim.api.nvim_set_current_win(testwinnr)

    -- vim.treesitter.start(testbufnr, lang)
  end)

  after_each(function()
    vim.treesitter.stop(testbufnr)

    if
      testbufnr ~= nil
      and vim.api.nvim_buf_is_valid(testbufnr)
      and vim.api.nvim_buf_is_loaded(testbufnr)
    then
      vim.api.nvim_buf_delete(testbufnr, { force = true })
    end

    testwinnr = nil
    testbufnr = nil

    vim.api.nvim_set_current_win(prevwinnr)
  end)

  -- Helpers.

  ---@param lang string
  ---@param content string[]
  local function set_content(lang, content)
    vim.treesitter.stop(testbufnr)

    vim.api.nvim_set_option_value("filetype", lang, { buf = testbufnr })
    vim.api.nvim_buf_set_lines(testbufnr, 0, -1, false, content)

    vim.treesitter.start(testbufnr, lang)
  end

  ---@param line number
  ---@param col number?
  local function set_cursor(line, col)
    col = col or 0

    vim.api.nvim_win_set_cursor(testwinnr, { line, col })
  end

  describe("go", function()
    describe("function_name_at_cursor()", function()
      it("should work", function()
        assert.has_no.errors(function()
          set_content("go", {
            "package printer",
            "",
            "func Print() {",
            "  if true {",
            "    print(10)", -- CURSOR
            "  }",
            "}",
          })
          set_cursor(5, 5)

          local _ = languages.go.function_name_at_cursor(testwinnr)
        end)
      end)

      it("should return function name", function()
        set_content("go", {
          "package printer",
          "",
          "func Print() {",
          "  if true {",
          "    print(10)", -- CURSOR
          "  }",
          "}",
        })
        set_cursor(5, 5)

        local got = languages.go.function_name_at_cursor(testwinnr)
        assert.same("Print", got)
      end)

      it("should return method name", function()
        set_content("go", {
          "package printer",
          "",
          "type Printer struct{}",
          "",
          "func (*Printer) Print() {",
          "  if true {",
          "    print(10)", -- CURSOR
          "  }",
          "}",
        })
        set_cursor(7, 5)

        local got = languages.go.function_name_at_cursor(testwinnr)
        assert.same("Print", got)
      end)

      it("should return nil if the curser outside of the function", function()
        set_content("go", {
          "package printer",
          "", -- CURSOR
          "func Print() {",
          "  if true {",
          "    print(10)",
          "  }",
          "}",
        })
        set_cursor(1, 0)

        local got = languages.go.function_name_at_cursor(testwinnr)
        assert.same(nil, got)
      end)

      it("should return nil if the curser inside of func literal", function()
        set_content("go", {
          "package printer",
          "",
          "func Print() {",
          "  a := func() {",
          "    print(10)", -- CURSOR
          "  }",
          "}",
        })
        set_cursor(5, 0)

        local got = languages.go.function_name_at_cursor(testwinnr)
        assert.same(nil, got)
      end)

      describe("top = true", function()
        it("should return top function name", function()
          set_content("go", {
            "package printer",
            "",
            "func Print() {",
            "  a := func() {",
            "    print(10)", -- CURSOR
            "  }",
            "}",
          })
          set_cursor(5, 0)

          local got = languages.go.function_name_at_cursor(testwinnr, {
            top = true,
          })
          assert.same("Print", got)
        end)
      end)
    end)
  end)
end)
