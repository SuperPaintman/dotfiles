local daemons = {
  cpu = require("daemons.cpu"),
  ram = require("daemons.ram"),
  wifi_status = require("daemons.wifi_status"),
  battery = require("daemons.battery"),
}

return daemons
