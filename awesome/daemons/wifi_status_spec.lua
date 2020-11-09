_G._TEST = true

require("mocks.awesome")
local mock_watch = require("mocks.awful.widget.watch")

local wifi_status = require("daemons.wifi_status")

local connected_result = [[connected ramen-wf 80
]]

local disconnected_result = [[disconnected
]]

describe("daemons.wifi_status", function()
    describe("private", function()
        describe("parse_result", function()
            local parse_result = wifi_status._private.parse_result

            context("connected", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result(connected_result, 0)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, signal, ok = parse_result(connected_result, 0)

                    assert.is_true(ok)
                    assert.is.equal(status, wifi_status.status_connected)
                    assert.is.equal(name, "ramen-wf")
                    assert.is.equal(signal, 80)
                end)
            end)

            context("disconnected", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result(disconnected_result, 0)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, signal, ok = parse_result(disconnected_result, 0)

                    assert.is_true(ok)
                    assert.is.equal(status, wifi_status.status_disconnected)
                    assert.is.equal(name, "")
                    assert.is.equal(signal, 0)
                end)
            end)

            context("error exit code", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result("", 1)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, signal, ok = parse_result("", 1)

                    assert.is_true(ok)
                    assert.is.equal(status, wifi_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(signal, 0)
                end)

                it("should ignore even valid connected string", function()
                    local status, name, signal, ok = parse_result(connected_result, 1)

                    assert.is_true(ok)
                    assert.is.equal(status, wifi_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(signal, 0)
                end)

                it("should ignore even valid disconnected string", function()
                    local status, name, signal, ok = parse_result(status_disconnected, 1)

                    assert.is_true(ok)
                    assert.is.equal(status, wifi_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(signal, 0)
                end)
            end)

            for i, v in ipairs({
                {"empty", ""},
                {"nil", nil},
                {"broken connected", "connected ramen-wf"},
                {"broken disconnected", "disconnect"},
            }) do
                local name, value = v[1], v[2]

                context(name.." input", function()
                    it("should work", function()
                        assert.has_no.errors(function()
                            parse_result(value)
                        end)
                    end)

                    it("should return zero values", function()
                        local status, name, signal, ok = parse_result(value, 0)

                        assert.is_false(ok)
                        assert.is.equal(status, "")
                        assert.is.equal(name, "")
                        assert.is.equal(signal, 0)
                    end)
                end)
            end
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
            w.callback(nil, [[connected ramen-wf 80]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_connected, "ramen-wf", 80)
            awesome.emit_signal:clear()

            -- Valid second call.
            w.callback(nil, [[connected ramen-wf 60]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_connected, "ramen-wf", 60)
            awesome.emit_signal:clear()

            -- Valid third call.
            w.callback(nil, [[disconnected]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_disconnected, "", 0)
            awesome.emit_signal:clear()

            -- Valid fourth call.
            w.callback(nil, [[connected ramen-wf 65]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_connected, "ramen-wf", 65)
            awesome.emit_signal:clear()

            -- Invalid fifth call.
            w.callback(nil, [[]], "", "", 1)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_error, "", 0)
            awesome.emit_signal:clear()

            -- Valid sixth call.
            w.callback(nil, [[connected ramen-wf 55]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::wifi", wifi_status.status_connected, "ramen-wf", 55)
            awesome.emit_signal:clear()
        end)
    end)
end)
