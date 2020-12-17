local upower_path = [[/org/freedesktop/UPower/devices/battery_BAT0
]]

local upower_info_discharging = [[  native-path:          BAT0
  vendor:               SMP
  model:                DELL GPM0365
  serial:               59
  power supply:         yes
  updated:              Mon 1 Jan 2020 12:00:00 PM MSK (30 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               discharging
    warning-level:       none
    energy:              69.312 Wh
    energy-empty:        0 Wh
    energy-full:         97.0026 Wh
    energy-full-design:  97.0026 Wh
    energy-rate:         13.851 W
    voltage:             11.959 V
    time to empty:       5.0 hours
    percentage:          71%
    capacity:            100%
    technology:          lithium-ion
    icon-name:          'battery-full-symbolic'
  History (charge):
    1608149461  71.000  discharging
  History (rate):
    1608149461  13.851  discharging

]]

local upower_info_discharging_without_time = [[  native-path:          BAT0
  vendor:               SMP
  model:                DELL GPM0365
  serial:               59
  power supply:         yes
  updated:              Mon 1 Jan 2020 12:00:00 PM MSK (30 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               discharging
    warning-level:       none
    energy:              97.0026 Wh
    energy-empty:        0 Wh
    energy-full:         97.0026 Wh
    energy-full-design:  97.0026 Wh
    energy-rate:         0.0114 W
    voltage:             13.214 V
    percentage:          100%
    capacity:            100%
    technology:          lithium-ion
    icon-name:          'battery-full-symbolic'

]]

local upower_info_charging = [[  native-path:          BAT0
  vendor:               SMP
  model:                DELL GPM0365
  serial:               59
  power supply:         yes
  updated:              Mon 1 Jan 2020 12:00:00 PM MSK (30 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               charging
    warning-level:       none
    energy:              4.8564 Wh
    energy-empty:        0 Wh
    energy-full:         97.0026 Wh
    energy-full-design:  97.0026 Wh
    energy-rate:         47.6406 W
    voltage:             11.385 V
    time to full:        1.9 hours
    percentage:          5%
    capacity:            100%
    technology:          lithium-ion
    icon-name:          'battery-caution-charging-symbolic'
  History (charge):
    1608230278	5.000	charging
    1608230277	0.000	unknown
  History (rate):
    1608230278	47.641	charging
    1608230277	0.000	unknown

]]

local upower_info_fully_charged = [[  native-path:          BAT0
  vendor:               SMP
  model:                DELL GPM0365
  serial:               59
  power supply:         yes
  updated:              Mon 1 Jan 2020 12:00:00 PM MSK (30 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               fully-charged
    warning-level:       none
    energy:              97.0026 Wh
    energy-empty:        0 Wh
    energy-full:         97.0026 Wh
    energy-full-design:  97.0026 Wh
    energy-rate:         0.0114 W
    voltage:             13.214 V
    percentage:          100%
    capacity:            100%
    technology:          lithium-ion
    icon-name:          'battery-full-charged-symbolic'

]]
