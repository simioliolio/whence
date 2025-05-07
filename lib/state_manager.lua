local StateManager = {}

function StateManager.new(initial_state)
  local self = {
    state = initial_state,
    listeners = {
      on_state_change = nil
    }
  }

  function self:reduce(event, reducer)
    local new_state = reducer:reduce(event, self.state)
    self.state = new_state
    if self.listeners.on_state_change then
      self.listeners.on_state_change(new_state)
    end
  end

  return self
end

return StateManager 