-- Whence

-- Development notes:
-- norns core lib types are only used in this file. Abstractions for grid, clock etc are used
-- under lib/ (for unit testing)
--

require "whence.lib.coordinator"

function init()
  local coordinator = Coordinator.new()
  g = grid.connect()
  g.key = coordinator.grid_button_handler
  coordinator.led_set = g.led
  coordinator.led_refresh = g.refresh
  coordinator.start()
end
