_G._TEST = true

require("mocks.awesome")
local mock_watch = require("mocks.awful.widget.watch")

local vpn_status = require("daemons.vpn_status")

local connected_result = [[connected my-test-vpn 10.0.0.1
]]

local connected_unknown_result = [[connected <unknown> 10.0.0.1
]]

local connecting_result = [[connecting my-test-vpn 10.0.0.1
]]

local disconnected_result = [[disconnected
]]

describe("daemons.vpn_status", function()
    describe("private", function()
        describe("parse_result", function()
            local parse_result = vpn_status._private.parse_result

            context("connected", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result(connected_result, 0)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, ip, ok = parse_result(connected_result, 0)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_connected)
                    assert.is.equal(name, "my-test-vpn")
                    assert.is.equal(ip, "10.0.0.1")
                end)

                context("unknown config", function()
                    it("should work", function()
                        assert.has_no.errors(function()
                            parse_result(connected_unknown_result, 0)
                        end)
                    end)

                    it("should return parsed stats", function()
                        local status, name, ip, ok = parse_result(connected_unknown_result, 0)

                        assert.is_true(ok)
                        assert.is.equal(status, vpn_status.status_connected)
                        assert.is.equal(name, "<unknown>")
                        assert.is.equal(ip, "10.0.0.1")
                    end)
                end)
            end)

            context("connecting", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result(connecting_result, 0)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, ip, ok = parse_result(connecting_result, 0)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_connecting)
                    assert.is.equal(name, "my-test-vpn")
                    assert.is.equal(ip, "10.0.0.1")
                end)
            end)

            context("disconnected", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result(disconnected_result, 0)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, ip, ok = parse_result(disconnected_result, 0)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_disconnected)
                    assert.is.equal(name, "")
                    assert.is.equal(ip, "")
                end)
            end)

            context("error exit code", function()
                it("should work", function()
                    assert.has_no.errors(function()
                        parse_result("", 1)
                    end)
                end)

                it("should return parsed stats", function()
                    local status, name, ip, ok = parse_result("", 1)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(ip, "")
                end)

                it("should ignore even valid connected string", function()
                    local status, name, ip, ok = parse_result(connected_result, 1)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(ip, "")
                end)

                it("should ignore even valid connectiong string", function()
                  local status, name, ip, ok = parse_result(status_connecting, 1)

                  assert.is_true(ok)
                  assert.is.equal(status, vpn_status.status_error)
                  assert.is.equal(name, "")
                  assert.is.equal(ip, "")
              end)

                it("should ignore even valid disconnected string", function()
                    local status, name, ip, ok = parse_result(status_disconnected, 1)

                    assert.is_true(ok)
                    assert.is.equal(status, vpn_status.status_error)
                    assert.is.equal(name, "")
                    assert.is.equal(ip, "")
                end)
            end)

            for i, v in ipairs({
                {"empty", ""},
                {"nil", nil},
                {"broken connected", "connected my-test-vpn"},
                {"broken connected unknown", "connected <unknown>"},
                {"broken connecting", "connecting my-test-vpn"},
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
                        local status, name, ip, ok = parse_result(value, 0)

                        assert.is_false(ok)
                        assert.is.equal(status, "")
                        assert.is.equal(name, "")
                        assert.is.equal(ip, "")
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
            w.callback(nil, [[connecting my-test-vpn 10.0.0.0]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_connecting, "my-test-vpn", "10.0.0.0")
            awesome.emit_signal:clear()

            -- Valid second call.
            w.callback(nil, [[connected my-test-vpn 10.0.0.0]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_connected, "my-test-vpn", "10.0.0.0")
            awesome.emit_signal:clear()

            -- Valid third call.
            w.callback(nil, [[disconnected]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_disconnected, "", "")
            awesome.emit_signal:clear()

            -- Valid fourth call.
            w.callback(nil, [[connected my-test-vpn 10.0.0.0]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_connected, "my-test-vpn", "10.0.0.0")
            awesome.emit_signal:clear()

            -- Invalid fifth call.
            w.callback(nil, [[]], "", "", 1)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_error, "", "")
            awesome.emit_signal:clear()

            -- Valid sixth call.
            w.callback(nil, [[connected my-test-vpn 10.0.0.0]], "", "", 0)
            assert.spy(awesome.emit_signal).was.called(1)
            assert.spy(awesome.emit_signal).was.called_with("daemons::vpn", vpn_status.status_connected, "my-test-vpn", "10.0.0.0")
            awesome.emit_signal:clear()
        end)
    end)
end)
