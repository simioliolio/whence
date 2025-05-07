local Sequencer = {}

function Sequencer.new()
  local self = {
    position = 0,
    length = 16,
    notes = {},
    listeners = {
      on_advance = nil
    }
  }

  function self:advance()
    self.position = (self.position + 1) % self.length
    if self.listeners.on_advance then
      self.listeners.on_advance()
    end
  end

  function self:set_notes(pos, notes)
    self.notes[pos] = notes
  end

  function self:notes_for_current_position()
    return self.notes[self.position]
  end

  function self:reset()
    self.position = 0
  end

  return self
end

return Sequencer
