local EventReducer = {}

function EventReducer.new()
  local self = {}

  -- Returns a _modified_ state based on the button model
  function self:reduce(button_event, state)
    state.selected_page = button_event.sequencer_page
    if button_event.play_stop_toggled_event then
      state.play_requested = not state.play_requested
    end
    if button_event.held_page_button then
      state.showing_transport_row = true
    else
      state.showing_transport_row = false
    end
    state.latest_button_event = button_event
    return state
  end

  return self
end

return EventReducer
