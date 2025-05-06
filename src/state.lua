local State = {}

function State.new()
  local self = {
    -- Buttons
    selected_page = 1,
    play_requested = false,
    showing_transport_row = false,
    latest_button_event = nil, -- ButtonEvent

    -- Sequencing
    is_playing = false, -- true if the sequencer is playing
    sequence = {}, -- {step(int), {midi_note(int), length(int), velocity(int)}}
  }

  return self
end

return State
