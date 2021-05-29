local daemons = {
  wifi_status = require("daemons.wifi_status"),
  vpn_status = require("daemons.vpn_status"),
  battery = require("daemons.battery"),
  monitroid = require("daemons.monitroid"),
  volume = require("daemons.volume"),
  brightness = require("daemons.brightness"),
}

return daemons
