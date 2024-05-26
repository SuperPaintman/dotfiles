--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ignore = require("utils.ignore")

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.ignore", function()
  describe("parse()", function()
    it("should parse empty", function()
      local content = {}

      local got = ignore.parse(content)
      local want = {}

      assert.same(want, got)
    end)

    it("should parse signle line", function()
      local content = {
        "*.go",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = "*.go", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should parse multiple lines", function()
      local content = {
        ".git",
        "*.go",
        "frontend/**/*.js",
        "/secrets",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = ".git", allowed = false },
        { pattern = "*.go", allowed = false },
        { pattern = "frontend/**/*.js", allowed = false },
        { pattern = "/secrets", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should ignore comments", function()
      local content = {
        "# This is a comment",
        "*.go",
        "frontend/**/*.js",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = "*.go", allowed = false },
        { pattern = "frontend/**/*.js", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should ignore empty lines", function()
      local content = {
        "",
        "\t\t\t",
        ".git",
        "",
        "    ",
        "*.go",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = ".git", allowed = false },
        { pattern = "*.go", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should parse negative expressions", function()
      local content = {
        "!*.env",
        "!/secrets/*.env",
        "*.log",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = "*.env", allowed = true },
        { pattern = "/secrets/*.env", allowed = true },
        { pattern = "*.log", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should trim spaces on the right side", function()
      local content = {
        "*.go    ",
        "   ",
        "frontend/**/*.js     ",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = "*.go", allowed = false },
        { pattern = "frontend/**/*.js", allowed = false },
      }

      assert.same(want, got)
    end)

    it("should trim \\t, \\r and \\n on the right side", function()
      local content = {
        "*.go\t    \r\n",
        "   \n",
        "frontend/**/*.js     \r",
        "*.log\n",
      }

      local got = ignore.parse(content)
      local want = {
        { pattern = "*.go", allowed = false },
        { pattern = "frontend/**/*.js", allowed = false },
        { pattern = "*.log", allowed = false },
      }

      assert.same(want, got)
    end)
  end)

  describe("matches()", function()
    it("should match the global wildcard", function()
      local pattern = "*"

      local valid = {
        "main.go",
        "internal/strings/strings.go",
        ".go",
        "main.go.txt",
        "strings.go/README.md",
        "main.rs",
      }
      for _, filename in ipairs(valid) do
        local got = ignore.matches(pattern, filename)
        assert(got, filename)
      end
    end)

    it("should match a wildcard with ext", function()
      local pattern = "*.go"

      local valid = {
        "main.go",
        "internal/strings/strings.go",
        ".go",
      }
      for _, filename in ipairs(valid) do
        local got = ignore.matches(pattern, filename)
        assert(got, filename)
      end

      local invalid = {
        "main.go.txt",
        "strings.go/README.md",
        "main.rs",
      }
      for _, filename in ipairs(invalid) do
        local got = ignore.matches(pattern, filename)
        assert(not got, filename)
      end
    end)

    it("should match a recursive wildcard", function()
      local pattern = "cmd/**/main.go"

      local valid = {
        "cmd/main.go",
        "cmd/my-cli/main.go",
        "cmd/my-cli/a/b/c/main.go",
      }
      for _, filename in ipairs(valid) do
        local got = ignore.matches(pattern, filename)
        assert(got, filename)
      end

      local invalid = {
        "cmd",
        "cmd/",
        "cmd/my-cli",
        "cmd/my-cli/main.rs",
      }
      for _, filename in ipairs(invalid) do
        local got = ignore.matches(pattern, filename)
        assert(not got, filename)
      end
    end)

    it("should ignore invalid patterns", function()
      local pattern = "cmd/******/main.go"

      local got = ignore.matches(pattern, "main.go")
      assert(not got)
    end)
  end)
end)
