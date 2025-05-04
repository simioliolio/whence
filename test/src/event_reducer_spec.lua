require 'busted'
local EventReducer = require 'src.event_reducer'
local EventModel = require 'src.event_model'
local State = require 'src.state'

describe("EventReducer", function()
  it("should update the selected page", function()
    local event_reducer = EventReducer.new()
    local event_model = EventModel.new()
    event_model.sequencer_page = 1
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(1, new_state.selected_page)
  end)

  it("should update the is_playing state", function()
    local event_reducer = EventReducer.new()
    local event_model = EventModel.new()
    event_model.play_stop_toggled_event = true
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(true, new_state.is_playing)
  end)

  it("should update the showing_transport_row state", function()
    local event_reducer = EventReducer.new()
    local event_model = EventModel.new()
    event_model.held_page_button = true
    local state = State.new()
    local new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(true, new_state.showing_transport_row)
    event_model.held_page_button = false
    new_state = event_reducer:reduce(event_model, state)
    assert.are.equal(false, new_state.showing_transport_row)
  end)
end)