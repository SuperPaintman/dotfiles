--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local colors = require("utils.colors")

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------
describe("utils.colors", function()
  describe("RGB", function()
    describe(".new()", function()
      it("should work", function()
        assert.has_no.errors(function()
          local _ = colors.RGB.new(255, 0, 0)
        end)
      end)

      it("should return an instance of RGB", function()
        local color = colors.RGB.new(255, 0, 0)

        assert.same(colors.RGB, getmetatable(color))
      end)

      it("should work with hex strings", function()
        local color = colors.RGB.new("#FF8000")

        assert.same("RGB(255, 128, 0)", tostring(color))
      end)

      it("should throw an error when string is invalid", function()
        assert.has_error(function()
          local _ = colors.RGB.new("Hello")
        end)
      end)
    end)

    describe(":__tostring()", function()
      it("should work", function()
        local color = colors.RGB.new(255, 0, 0)

        assert.has_no.errors(function()
          local _ = tostring(color)
        end)
      end)

      it("should return the string representation of the RGB", function()
        local color = colors.RGB.new(255, 128, 0)

        assert.same("RGB(255, 128, 0)", tostring(color))
      end)
    end)

    describe(":to_hex()", function()
      it("should work", function()
        local color = colors.RGB.new(255, 0, 0)

        assert.has_no.errors(function()
          local _ = color:to_hex()
        end)
      end)

      it("should return the hex representation of the RGB", function()
        local color = colors.RGB.new(255, 128, 0)

        assert.same("#FF8000", color:to_hex())
      end)
    end)

    describe(":mix()", function()
      it("should work", function()
        local color1 = colors.RGB.new(255, 0, 0)
        local color2 = colors.RGB.new(0, 0, 255)

        assert.has_no.errors(function()
          local _ = color1:mix(color2, 0.5)
        end)
      end)

      it("should return correct mix", function()
        local color1 = colors.RGB.new(255, 0, 0)
        local color2 = colors.RGB.new(0, 0, 255)

        assert.same("RGB(255, 0, 0)", tostring(color1:mix(color2, 0.0)))
        assert.same("RGB(204, 0, 51)", tostring(color1:mix(color2, 0.2)))
        assert.same("RGB(127, 0, 127)", tostring(color1:mix(color2, 0.5)))
        assert.same("RGB(0, 0, 255)", tostring(color1:mix(color2, 1.0)))
      end)
    end)
  end)
end)
