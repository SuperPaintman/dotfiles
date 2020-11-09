local daemons = {
  cpu = require("daemons.cpu"),
  ram = require("daemons.ram"),
  wifi_status = require("daemons.wifi_status"),
}

return daemons
