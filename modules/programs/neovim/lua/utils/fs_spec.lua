--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local fs = require("utils.fs")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local uv = vim.loop

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param path string
local function mkdirp(path)
  vim.fn.mkdir(path, "p")
end

---@param path string
local function rmrf(path)
  vim.fn.delete(path, "rf")
end

---@param path string
---@param lines string[]?
local function create_file(path, lines)
  if lines == nil then
    lines = {}
  end

  local f = uv.fs_open(path, "w", 420) -- 0644
  assert(f ~= nil, string.format("create_file: failed to open file: %s", path))

  uv.fs_write(f, table.concat(lines, "\n"), -1)

  local ok, err_name, err_msg = uv.fs_close(f)
  assert(
    ok,
    string.format(
      "create_file: failed to close file: %s: %s: %s",
      path,
      err_name,
      err_msg
    )
  )
end

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.fs", function()
  before_each(function()
    mkdirp(".tests/testdata/utils.fs")
  end)

  after_each(function()
    rmrf(".tests/testdata/utils.fs")
  end)

  describe("find_ancestor()", function()
    it("should work", function()
      create_file(".tests/testdata/utils.fs/test.txt")

      fs.find_ancestor(".tests/testdata/utils.fs", { "test.txt" })
    end)

    it("should find a file on the same level", function()
      create_file(".tests/testdata/utils.fs/test.txt")

      local got = fs.find_ancestor(".tests/testdata/utils.fs/", { "test.txt" })
      local want = ".tests/testdata/utils.fs"

      assert.same(want, got)
    end)

    it("should find a file in an ancestor directory", function()
      mkdirp(".tests/testdata/utils.fs/a/b/c/d/e")

      create_file(".tests/testdata/utils.fs/a/b/c/test.txt")

      local got =
        fs.find_ancestor(".tests/testdata/utils.fs/a/b/c/d/e", { "test.txt" })
      local want = ".tests/testdata/utils.fs/a/b/c"

      assert.same(want, got)
    end)

    it("should find the first file in ancestor directories", function()
      mkdirp(".tests/testdata/utils.fs/a/b/c/d/e")

      create_file(".tests/testdata/utils.fs/a/test.txt")
      create_file(".tests/testdata/utils.fs/a/b/c/test.txt")
      create_file(".tests/testdata/utils.fs/a/b/c/d/test.txt")

      local got =
        fs.find_ancestor(".tests/testdata/utils.fs/a/b/c/d/e", { "test.txt" })
      local want = ".tests/testdata/utils.fs/a/b/c/d"

      assert.same(want, got)
    end)
  end)

  describe("find_ancestors()", function()
    it("should work", function()
      create_file(".tests/testdata/utils.fs/test.txt")

      fs.find_ancestors(".tests/testdata/utils.fs", { "test.txt" })
    end)

    it("should find a file on the same level", function()
      create_file(".tests/testdata/utils.fs/test.txt")

      local got = fs.find_ancestors(".tests/testdata/utils.fs/", { "test.txt" })
      local want = { ".tests/testdata/utils.fs" }

      assert.same(want, got)
    end)

    it("should find a file in an ancestor directory", function()
      mkdirp(".tests/testdata/utils.fs/a/b/c/d/e")

      create_file(".tests/testdata/utils.fs/a/b/c/test.txt")

      local got =
        fs.find_ancestors(".tests/testdata/utils.fs/a/b/c/d/e", { "test.txt" })
      local want = { ".tests/testdata/utils.fs/a/b/c" }

      assert.same(want, got)
    end)

    it("should find multiple files in ancestor directories", function()
      mkdirp(".tests/testdata/utils.fs/a/b/c/d/e")

      create_file(".tests/testdata/utils.fs/a/test.txt")
      create_file(".tests/testdata/utils.fs/a/b/c/test.txt")
      create_file(".tests/testdata/utils.fs/a/b/c/d/test.txt")

      local got =
        fs.find_ancestors(".tests/testdata/utils.fs/a/b/c/d/e", { "test.txt" })
      local want = {
        ".tests/testdata/utils.fs/a/b/c/d",
        ".tests/testdata/utils.fs/a/b/c",
        ".tests/testdata/utils.fs/a",
      }

      assert.same(want, got)
    end)
  end)
end)
