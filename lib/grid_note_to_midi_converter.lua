local GridNoteToMidiConverter = {}

GridNoteToMidiConverter.ROWS = 5
GridNoteToMidiConverter.COLS = 16

GridNoteToMidiConverter.BOTTOM_ROW = 5
GridNoteToMidiConverter.TOP_ROW = 1

-- The number of chromatic steps jumped between grid notes in one column
GridNoteToMidiConverter.ROW_NOTE_DELTA = 5

function GridNoteToMidiConverter.new()
  local self = {
    lowest_midi_note = 21,
  }

  function self:convert(grid_note)
    assert(grid_note.x >= 1 and grid_note.x <= GridNoteToMidiConverter.COLS, "Invalid grid note x")
    assert(grid_note.y >= 1 and grid_note.y <= GridNoteToMidiConverter.ROWS, "Invalid grid note y")
    -- Invert the y axis so that the bottom row is 0 and the top row is 4
    local inverted_y_scalar = GridNoteToMidiConverter.ROWS - grid_note.y
    local y_midi_delta = (inverted_y_scalar * GridNoteToMidiConverter.ROW_NOTE_DELTA)
    local x_midi_delta = grid_note.x - 1
    return self.lowest_midi_note + y_midi_delta + x_midi_delta
  end

  return self
end

return GridNoteToMidiConverter
