local EventModel = {}

function EventModel.new()
    local self = {
      -- event-like state. usually nil next on_change
      play_stop_toggled_event = nil,  -- Start as nil
      grid_note_sequencer_event = nil,  -- Track the current grid note being toggled
      grid_note_play_event = nil,  -- Forward raw grid note events
      
      -- state which needs to persist between presses
      sequencer_page = 0,
      held_page_button = nil,  -- Track which page button is being held
      held_sequencer_position = nil,  -- Track which sequencer position is being held (0-31)
    }

    return self
end

return EventModel
