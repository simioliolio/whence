local EventReducer = {}

function EventReducer.new()
  local self = {}

  -- Returns a _modified_ state based on the button model
  function self:reduce(button_event, state)
    state.selected_page = event_model.sequencer_page
    if event_model.play_stop_toggled_event then
      state.play_requested = not state.play_requested
    end
    if event_model.held_page_button then
      state.showing_transport_row = true
    else
      state.showing_transport_row = false
    end
    state.latest_button_event = event_model
    return state
  end

  return self
end

return EventReducer
