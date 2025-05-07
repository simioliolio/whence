-- Whence

-- Development notes:
-- norns core lib types are only used in this file. Abstractions for grid, clock etc are used
-- under lib/ (for unit testing)
--

local Coordinator = {}

function Coordinator.new()
  local self = {
    -- set externally
    led_set = function (_,_,_) assert(false, "not set") end,
    led_refresh = function() assert(false, "not set") end,

    grid_button_handler = function (x,y,z) self:handle_button(x,y,z) end,
  }

  function self:start()
    print("start called")
  end

  function self:handle_button(x,y,z)
    print("handling button " .. x .. y .. z)
  end

  return self
end


function init()
  local coordinator = Coordinator.new()
  g = grid.connect()
  g.key = coordinator.grid_button_handler
  coordinator.led_set = g.led
  coordinator.led_refresh = g.refresh
  coordinator:start()
end
