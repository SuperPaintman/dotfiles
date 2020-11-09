_G._TEST = true

require("mocks.awesome")
local mock_watch = require("mocks.awful.widget.watch")

local ram = require("daemons.ram")

local free = [[              total        used        free      shared  buff/cache   available
Mem:       10000000     6000000     4000000      400000     5000000     9000000
Swap:       8000000           0     8000000
]]

local free_broken = [[              total        used        free      shared  buff/cache   available
Mem:       16243776     5888208     4820552      414380     5535016
]]

describe("daemons.ram", function()
    describe("private", function()
        describe("parse_free", function()
            local parse_free = ram._private.parse_free

            context("valid input", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_free(free)
                    end)
                end)

                it("should return parsed stats", function()
                    local total, used, ok = parse_free(free)

                    assert.is_true(ok)
                    assert.is.equal(total, 10000000)
                    assert.is.equal(used, 6000000)
                end)
            end)

            for i, v in ipairs({
                {"empty", ""},
                {"nil", nil},
                {"broken", free_broken},
            }) do
                local name, value = v[1], v[2]

                context(name.." input", function()
                    it("should work", function()
                        assert.has_no.errors(function()
                            parse_free(value)
                        end)
                    end)

                    it("should return zero values", function()
                        local total, used, ok = parse_free(value)

                        assert.is_false(ok)
                        assert.is.equal(total, 0)
                        assert.is.equal(used, 0)
                    end)
                end)
            end
        end)

        describe("calculate_usage", function()
            local calculate_usage = ram._private.calculate_usage

            it("should work", function()
                assert.has_no.errors(function()
                    calculate_usage(0, 0)
                end)
            end)

            context("integer usage", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(100, 10)

                    assert.is.equal(usage, 10)
                end)
            end)

            context("float usage", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(200, 1)

                    assert.is.equal(usage, 0.5)
                end)
            end)

            context("zero values", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(0, 0)

                    assert.is.equal(usage, 0)
                end)
            end)
        end)
    end)

    describe("watch", function()
        setup(function()
            spy.on(awesome, "emit_signal")
        end)

        teardown(function()
            awesome.emit_signal:revert()
        end)

        before_each(function()
            awesome.emit_signal:clear()
        end)

        it("should be only one watch in table", function()
            assert.is.equal(#mock_watch.watches, 1)
        end)

        it("should emit valid signals", function()
            local w = mock_watch.watches[1]

            assert.spy(awesome.emit_signal).was_not.called()

            -- Valid first call.
            w.callback(nil, free)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::ram", 60)
            awesome.emit_signal:clear()

            -- Valid second call.
            w.callback(nil, [[              total        used        free      shared  buff/cache   available
            Mem:       10000000     7000000     3000000      400000     5000000     9000000
            Swap:       8000000           0     8000000
            ]])
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::ram", 70)
            awesome.emit_signal:clear()
        end)
    end)
end)
