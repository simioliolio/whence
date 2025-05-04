local GridNoteToMidiConverter = {}

GridNoteToMidiConverter.ROWS = 5
GridNoteToMidiConverter.COLS = 16
GridNoteToMidiConverter.BOTTOM_ROW = 4
GridNoteToMidiConverter.TOP_ROW = 0

-- The number of chromatic steps jumped between grid notes in one column
GridNoteToMidiConverter.ROW_NOTE_DELTA = 5

function GridNoteToMidiConverter.new()
  local self = {
    lowest_midi_note = 21,
  }

  function self:convert(grid_note)
    assert(grid_note.x >= 0 and grid_note.x < GridNoteToMidiConverter.COLS, "Invalid grid note x")
    assert(grid_note.y >= 0 and grid_note.y < GridNoteToMidiConverter.ROWS, "Invalid grid note y")
    -- Invert the y axis so that the bottom row is 0 and the top row is 4
    local inverted_y = GridNoteToMidiConverter.ROWS - grid_note.y
    local y_midi = (inverted_y * GridNoteToMidiConverter.ROW_NOTE_DELTA)
    return self.lowest_midi_note + y_midi + grid_note.x
  end

  return self
end

return GridNoteToMidiConverter
