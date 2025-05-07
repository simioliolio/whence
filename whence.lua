-- Whence

-- Development notes:
-- norns core lib types are only used in this file. Abstractions for grid, clock etc are used
-- under lib/ (for unit testing)
--

local ButtonInterpreter = require "whence.lib.button_interpreter"
local EventReducer = require "whence.lib.event_reducer"
local State = require "whence.lib.state"
local StateManager = require "whence.lib.state_manager"

local Coordinator = {}

function Coordinator.new()
  local self = {
    -- set externally
    led_set = function (_,_,_) assert(false, "not set") end,
    led_refresh = function() assert(false, "not set") end,

    -- get externally
    grid_button_handler = function (x,y,z) self:handle_button(x,y,z) end,

    button_interpreter = ButtonInterpreter.new(),
    event_reducer = EventReducer.new(),
    state_manager = StateManager.new(State.new()),
  }

  function self:start()
    self.button_interpreter.listeners.on_change = function(event)
      self.state_manager:reduce(event, self.event_reducer)
    end

    self.state_manager.listeners.on_state_change = function(new_state)
      -- TODO: Update LEDs based on new state
    end
  end

  function self:handle_button(x,y,z)
    self.button_interpreter:handle_press({x,y,z})
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
