local EventReducer = {}
local GridNoteToMidiConverter = require 'whence.lib.grid_note_to_midi_converter'

-- Helper function to find an element in a table that matches a predicate
local function table_find(t, predicate)
  for i, v in ipairs(t) do
    if predicate(v) then
      return i, v
    end
  end
  return nil
end

function EventReducer.new()
  local self = {
    grid_note_to_midi_converter = GridNoteToMidiConverter.new(),
  }

  -- Returns a _modified_ state based on the button model
  function self:reduce(button_event, state)
    state.selected_page = button_event.sequencer_page
    if button_event.play_stop_toggled_event then
      state.play_requested = not state.play_requested
    end
    state.showing_transport_row = button_event.held_page_button ~= nil
    state.latest_button_event = button_event

    -- Toggle notes in the sequence best on grid-note events
    if button_event.grid_note_into_sequencer_event then
      local sequence_step = button_event.held_sequencer_position
      assert(sequence_step ~= nil, "sequencer grid note event when no held sequencer position")
      local grid_note = button_event.grid_note_into_sequencer_event
      local midi_note = self.grid_note_to_midi_converter:convert(grid_note)
      local notes_at_step = state.sequence[sequence_step]
      if notes_at_step == nil then
        state.sequence[sequence_step] = {{midi_note = midi_note, length = 1, velocity = 100}}
      else
        -- Find and remove if exists, otherwise add
        local index = table_find(notes_at_step, function(note) return note.midi_note == midi_note end)
        if index then
          table.remove(notes_at_step, index)
        else
          print("Adding note to sequence")
          table.insert(notes_at_step, {midi_note = midi_note, length = 1, velocity = 100})
        end
        state.sequence[sequence_step] = notes_at_step
      end
    end
    return state
  end

  return self
end

return EventReducer
