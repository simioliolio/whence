local State = {}

function State.new()
  local self = {
    selected_page = 1,
    play_requested = false,
    showing_transport_row = false,
    is_playing = false, -- true if the sequencer is playing
    latest_button_event = nil, -- the latest ButtonEvent
  }

  return self
end

return State
