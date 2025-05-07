require 'busted'
local EventReducer = require 'whence.lib.event_reducer'
local ButtonEvent = require 'whence.lib.button_event'
local State = require 'whence.lib.state'
local GridNoteMidiHelperStub = require 'whence.test.utils.grid_note_midi_converter_stub'

describe("EventReducer", function()
  it("should update the selected page", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    event_model.sequencer_page = 1
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(1, new_state.selected_page)
  end)

  it("should update the play_requested state", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    event_model.play_stop_toggled_event = true
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(true, new_state.play_requested)
  end)

  it("should update the showing_transport_row state", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    event_model.held_page_button = 1
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(true, new_state.showing_transport_row)
    event_model.held_page_button = nil
    new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(false, new_state.showing_transport_row)
  end)

  it("should assert if grid_note_into_sequencer_event but no held_sequencer_position", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    event_model.grid_note_into_sequencer_event = {x = 1, y = 1}
    event_model.held_sequencer_position = nil
    local state = State.new()
    assert.has_error(function()
      event_reducer:reduce(event_model, state)
    end)
  end)

  it("should toggle notes in the sequence", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    local grid_note_to_midi_converter = GridNoteMidiHelperStub.new()
    grid_note_to_midi_converter.midi_note_to_return = 42
    event_reducer.grid_note_to_midi_converter = grid_note_to_midi_converter
    local state = State.new()
    event_model.held_sequencer_position = 1

    -- Anything non-nil here is fine as we are stubbing the grid_note_to_midi_converter
    event_model.grid_note_into_sequencer_event = {x = 1, y = 1}

    local new_state = event_reducer:reduce(event_model, state)

    local expected_step = 1
    local notes_at_step = new_state.sequence[expected_step]
    assert.are.equal(42, notes_at_step[1].midi_note)
    assert.are.equal(1, notes_at_step[1].length)
    assert.are.equal(100, notes_at_step[1].velocity)

    -- Anything non-nil here is fine as we are stubbing the grid_note_to_midi_converter
    event_model.grid_note_into_sequencer_event = {x = 1, y = 1}

    new_state = event_reducer:reduce(event_model, state)

    local expected_step = 1
    local notes_at_step = new_state.sequence[expected_step]
    assert.same({}, notes_at_step)
  end)

  it("should toggle notes in the sequence when note is already in the sequence", function()
    local event_reducer = EventReducer.new()
    local event_model = ButtonEvent.new()
    local grid_note_to_midi_converter = GridNoteMidiHelperStub.new()
    grid_note_to_midi_converter.midi_note_to_return = 43
    event_reducer.grid_note_to_midi_converter = grid_note_to_midi_converter
    local state = State.new()
    state.sequence = {[1] = {{midi_note = 42, length = 1, velocity = 100}}}
    event_model.held_sequencer_position = 1

    -- Anything non-nil here is fine as we are stubbing the grid_note_to_midi_converter
    event_model.grid_note_into_sequencer_event = {x = 1, y = 1}

    local new_state = event_reducer:reduce(event_model, state)

    local expected_step = 1
    local notes_at_step = new_state.sequence[expected_step]
    -- Existing note should be first, followed by the new note
    assert.are.equal(42, notes_at_step[1].midi_note)
    assert.are.equal(1, notes_at_step[1].length)
    assert.are.equal(100, notes_at_step[1].velocity)
    assert.are.equal(43, notes_at_step[2].midi_note)
    assert.are.equal(1, notes_at_step[2].length)
    assert.are.equal(100, notes_at_step[2].velocity)
  end)
end)