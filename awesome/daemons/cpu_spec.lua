_G._TEST = true

require("mocks.awesome")
require("mocks.awful")
local mock_watch = require("mocks.awful.widget.watch")

local cpu = require("daemons.cpu")

local proc_cpu_stat = [[cpu  3000000 1000000 1000000 10000000 100000 0 900000 0 0 0
]]

describe("daemons.cpu", function()
    describe("private", function()
        describe("parse_proc_cpu_stat", function()
            local parse_proc_cpu_stat = cpu._private.parse_proc_cpu_stat

            context("valid input", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_proc_cpu_stat(proc_cpu_stat)
                    end)
                end)

                it("should return parsed stats", function()
                    local total, idle, ok = parse_proc_cpu_stat(proc_cpu_stat)

                    assert.is_true(ok)
                    assert.is.equal(total, 16000000)
                    assert.is.equal(idle, 10000000)
                end)
            end)

            for i, v in ipairs({
                {"empty", ""},
                {"nil", nil},
                {"broken", "cpu  4700703 386 1133175 71768322 72618"},
            }) do
                local name, value = v[1], v[2]

                context(name.." input", function()
                    it("should work", function()
                        assert.has_no.errors(function()
                            parse_proc_cpu_stat(value)
                        end)
                    end)

                    it("should return zero values", function()
                        local total, idle, ok = parse_proc_cpu_stat(value)

                        assert.is_false(ok)
                        assert.is.equal(total, 0)
                        assert.is.equal(idle, 0)
                    end)
                end)
            end
        end)

        describe("calculate_usage", function()
            local calculate_usage = cpu._private.calculate_usage

            it("should work", function()
                assert.has_no.errors(function()
                    calculate_usage(0, 0, 0, 0)
                end)
            end)

            context("zero previous values", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(0, 0, 100, 5)

                    assert.is.equal(usage, 95)
                end)
            end)

            context("non-zero previous values", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(100, 5, 120, 10)

                    assert.is.equal(usage, 75)
                end)
            end)

            context("float usage", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(1000, 51, 1600, 600)

                    assert.is.equal(usage, 8.5)
                end)
            end)

            context("unchanged values", function()
                it("should return valid usage", function()
                    local usage = calculate_usage(100, 5, 100, 5)

                    assert.is.equal(usage, 0)
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
                w.callback(nil, proc_cpu_stat)

                assert.spy(awesome.emit_signal).was.called(1)
                assert.spy(awesome.emit_signal).was.called_with("daemons::cpu", 37.5)
                awesome.emit_signal:clear()

                -- Valid second call.
                w.callback(nil, [[cpu  4000000 1000000 1000000 11000000 100000 0 900000 0 0 0
                ]])
                assert.spy(awesome.emit_signal).was.called(1)
                assert.spy(awesome.emit_signal).was.called_with("daemons::cpu", 50)
                awesome.emit_signal:clear()

                -- Invalid third call.
                w.callback(nil, nil)
                assert.spy(awesome.emit_signal).was_not.called()

                -- Valid fourth call.
                w.callback(nil, [[cpu  5000000 1000000 1000000 12500000 100000 0 900000 0 0 0
                ]])
                assert.spy(awesome.emit_signal).was.called(1)
                assert.spy(awesome.emit_signal).was.called_with("daemons::cpu", 40)
                awesome.emit_signal:clear()
            end)
        end)
    end)
end)
