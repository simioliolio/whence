require "busted"
local GridNoteToMidiConverter = require "src.grid_note_to_midi_converter"

describe("GridNoteToMidiConverter", function()
  it("should convert lowestgrid note to midi note", function()
    local converter = GridNoteToMidiConverter.new()
    local grid_note = {x = 1, y = 5}
    local midi_note = converter:convert(grid_note)
    assert.are.equal(21, midi_note)
  end)

  it("should offset the midi note by the lowest midi note", function()
    local converter = GridNoteToMidiConverter.new()
    converter.lowest_midi_note = 40
    local grid_note = {x = 1, y = 5}
    local midi_note = converter:convert(grid_note)
    assert.are.equal(40, midi_note)
  end)

  it("should convert grid note to midi note respecting x", function()
    local converter = GridNoteToMidiConverter.new()
    local grid_note = {x = 2, y = 5}
    local midi_note = converter:convert(grid_note)
    assert.are.equal(22, midi_note)
  end)

  it("should convert grid note to midi note respecting y", function()
    local converter = GridNoteToMidiConverter.new()
    local grid_note = {x = 1, y = 4}
    local midi_note = converter:convert(grid_note)
    assert.are.equal(26, midi_note)
  end)
end)
