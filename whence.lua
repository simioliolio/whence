-- Whence

-- Development notes:
-- norns lib types are only used in this file. Abstractions for grid, clock etc are used
-- under src/ (for unit testing)
--

require "src.coordinator"

function init()
  local coordinator = Coordinator.new()
  g = grid.connect()
  g.key = coordinator.grid_button_handler
  coordinator.led_set = g.led
  coordinator.led_refresh = g.refresh
  coordinator.start()
end
