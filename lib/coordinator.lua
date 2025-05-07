
local Coordinator = {}

function Coordinator.new()
  local self = {
    -- set externally
    led_set = function (_,_,_) assert(false, "not set") end,
    led_refresh = function() assert(false, "not set") end,

    grid_button_handler = function (x,y,z) self:handle_button(x,y,z) end,
  }

  function Coordinator:start()
    -- TODO: Setup
  end

  function Coordinator:handle_button(x,y,z)
    print("handling button " .. x .. y .. z)
  end

  return self
end

return Coordinator

