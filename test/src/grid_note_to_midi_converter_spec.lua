require "busted"
local GridNoteToMidiConverter = require "src.grid_note_to_midi_converter"

describe("GridNoteToMidiConverter", function()
  it("should convert grid note to midi note", function()
    local converter = GridNoteToMidiConverter.new()
    local grid_note = {x = 0, y = 0}
    local midi_note = converter:convert(grid_note)
    assert.are.equal(midi_note, 46)
  end)
end)