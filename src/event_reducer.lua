local EventReducer = {}

function EventReducer.new()
  local self = {}

  -- Returns a _modified_ state based on the event model
  function self:reduce(event_model, state)
    state.selected_page = event_model.sequencer_page
    if event_model.play_stop_toggled_event then
      state.is_playing = not state.is_playing
    end
    return state
  end

  return self
end

return EventReducer
