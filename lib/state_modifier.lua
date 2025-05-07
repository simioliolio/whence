local StateModifier = {}

function StateModifier.new(initial_state)
  -- Keep state in closure scope
  local state = initial_state

  local self = {
    listeners = {
      on_state_change = nil
    }
  }

  function self:get_state()
    return state
  end

  function self:reduce(event, reducer)
    local new_state = reducer:reduce(event, state)
    state = new_state
    if self.listeners.on_state_change then
      self.listeners.on_state_change(new_state)
    end
  end

  return self
end

return StateModifier 