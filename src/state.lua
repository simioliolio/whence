local State = {}

function State.new()
  local self = {
    selected_page = 1,
    play_requested = false,
    showing_transport_row = false,
    is_playing = false, -- true if the sequencer is playing
  }

  return self
end

return State
