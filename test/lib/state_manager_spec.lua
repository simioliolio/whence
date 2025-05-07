require 'busted'
local StateManager = require 'whence.lib.state_manager'
local State = require 'whence.lib.state'
local ButtonEvent = require 'whence.lib.button_event'

describe("StateManager", function()
  it("should update state and notify listeners", function()
    -- Create a simple reducer that just sets a value
    local reducer = {
      reduce = function(_, event, state)
        state.value = event.value
        return state
      end
    }

    local initial_state = State.new()
    local state_manager = StateManager.new(initial_state)

    local captured_state = nil
    state_manager.listeners.on_state_change = function(new_state)
      captured_state = new_state
    end

    local event = {value = 42}
    state_manager:reduce(event, reducer)

    assert.are.equal(42, captured_state.value)
  end)

  it("should maintain state between events", function()
    -- Create a reducer that accumulates values
    local reducer = {
      reduce = function(_, event, state)
        state.sum = (state.sum or 0) + event.value
        return state
      end
    }

    local initial_state = State.new()
    local state_manager = StateManager.new(initial_state)

    state_manager:reduce({value = 1}, reducer)
    state_manager:reduce({value = 2}, reducer)
    state_manager:reduce({value = 3}, reducer)

    assert.are.equal(6, state_manager.state.sum)
  end)

  it("should apply different reducers to the same state", function()
    -- Create two reducers that modify different parts of the state
    local reducer1 = {
      reduce = function(_, event, state)
        state.value1 = event.value
        return state
      end
    }

    local reducer2 = {
      reduce = function(_, event, state)
        state.value2 = event.value * 2
        return state
      end
    }

    local initial_state = State.new()
    local state_manager = StateManager.new(initial_state)

    state_manager:reduce({value = 42}, reducer1)
    state_manager:reduce({value = 42}, reducer2)

    assert.are.equal(42, state_manager.state.value1)
    assert.are.equal(84, state_manager.state.value2)
  end)
end) 