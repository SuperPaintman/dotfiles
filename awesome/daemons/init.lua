local daemons = {
  wifi_status = require("daemons.wifi_status"),
  battery = require("daemons.battery"),
  monitroid = require("daemons.monitroid"),
}

return daemons
