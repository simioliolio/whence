local GridNoteMidiHelperStub = {}

function GridNoteMidiHelperStub.new()
  local self = {
    midi_note_to_return = 42
  }

  function self:convert(grid_note)
    return self.midi_note_to_return
  end

  return self
end

return GridNoteMidiHelperStub
