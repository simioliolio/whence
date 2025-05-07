require 'busted'
local Sequencer = require 'whence.lib.sequencer'

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
    assert.are.same({60, 64, 67}, notes)
  end)

  it("should reset position", function()
    local sequencer = Sequencer.new()
    sequencer:advance()
    sequencer:reset()
    assert(sequencer.position == 0)
  end)

  it("should inform listeners that the sequencer advanced", function()
    local sequencer = Sequencer.new()
    local advanceCount = 0
    local advance = function()
      advanceCount = advanceCount + 1
    end
    sequencer.listeners.on_advance = advance
    sequencer:advance()
    assert(advanceCount == 1)
  end)

end)
