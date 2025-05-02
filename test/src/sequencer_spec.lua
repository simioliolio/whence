require 'busted'
local Sequencer = require 'src.sequencer'
local CompHelper = require 'test.utils.comparison_helper'

describe("Sequencer", function()
  it("should increase position when clocked", function()
    local sequencer = Sequencer.new()
    assert(sequencer.position == 0)
    sequencer:advance()
    assert(sequencer.position == 1)
  end)

  it("should wrap position after 16 steps", function()
    local sequencer = Sequencer.new()
    assert(sequencer.position == 0)
    for i = 1, 16 do
      sequencer:advance()
    end
    assert(sequencer.position == 0, "position was " .. sequencer.position)
  end)

  it("should allow a note to be set in the sequence", function ()
    local sequencer = Sequencer.new()
    sequencer:set_notes(0, {60})
    assert(sequencer.notes[0][1] == 60)
  end)

  it("should allow multiple notes to be set at a position", function()
    local sequencer = Sequencer.new()
    sequencer:set_notes(0, {60, 64, 67})
    assert(sequencer.notes[0][1] == 60)
    assert(sequencer.notes[0][2] == 64)
    assert(sequencer.notes[0][3] == 67)
  end)

  it("should provide notes for the current position", function()
    local sequencer = Sequencer.new()
    sequencer:set_notes(1, {60, 64, 67})
    local notes = sequencer:notes_for_current_position()
    assert(notes == nil)
    sequencer:advance()
    notes = sequencer:notes_for_current_position()
    assert(CompHelper.simple_arrays_are_equal(notes, {60, 64, 67}), "got " .. table.concat(notes))
  end)

  it("should reset position", function()
    local sequencer = Sequencer.new()
    sequencer:advance()
    sequencer:reset()
    assert(sequencer.position == 0)
  end)

end)
