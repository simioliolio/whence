require 'busted'
local ButtonInterpreter = require 'lib.button_interpreter'

describe("ButtonInterpreter", function()
  -- Helper function to create a fresh button interpreter with a listener
  local function setup_button_interpreter()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = button_interpreter  -- Start with the interpreter itself
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener
    return button_interpreter, captured_model
  end

  it("should set sequencer page numbers using row 7", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Test pages 1-4 using buttons 0-3
    for x = 0, 3 do
      button_interpreter:handle_press({x,7,1})  -- Only test button press (state = 1)
      assert.are.same(x + 1, captured_model.sequencer_page)
    end
  end)

  it("should interpret row 6 as transport when page button held", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Initial state
    assert(button_interpreter.play_stop_toggled_event == nil, "Initial state should be false")

    -- Press page button
    button_interpreter:handle_press({0,7,1})
    assert(button_interpreter.held_page_button == 0, "Page button should be held")

    -- Press transport button
    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled_event == true, "Transport should be toggled")
  end)

  it("should interpret row 6 as transport when page buttons held", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- A slightly more complex test involving when the page button is released

    -- Initial state
    assert(button_interpreter.play_stop_toggled_event == nil, "Initial state should be false")

    -- Press page button
    button_interpreter:handle_press({0,7,1})
    assert(button_interpreter.held_page_button == 0, "Page button 0 should be held")

    -- Press page button 1  
    button_interpreter:handle_press({1,7,1})
    assert(button_interpreter.held_page_button == 1, "Page button 1 should be held")

    -- Press transport button
    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled_event == true, "Transport should be toggled")

    -- Release page button 0
    button_interpreter:handle_press({1,7,0})
    assert(button_interpreter.held_page_button == nil, "Page button 1 should not be held")
  end)

  it("should not toggle transport when page button released", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Initial state
    assert(button_interpreter.play_stop_toggled_event == nil, "Initial state should be false")

    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled_event == nil, "Transport should not be toggled as we are not holding a page button")
    button_interpreter:handle_press({0,6,0})
    assert(button_interpreter.play_stop_toggled_event == nil, "Transport should not be toggled as we are not holding a page button")
  end)

  it("should not play when column 1 button is pressed when page button is held", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Press page button
    button_interpreter:handle_press({0,7,1})

    -- Press column 1 button
    button_interpreter:handle_press({0,1,1})
    assert(button_interpreter.play_stop_toggled_event == nil, "Transport should not be toggled as we are not pressing the transport button")
  end)

  it("should not report play_stop_toggled between on_change models", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Press page button
    button_interpreter:handle_press({0,7,1})

    -- Press transport button
    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled_event == true, "Transport should be toggled")

    -- Release page button
    button_interpreter:handle_press({0,7,0})
    assert(button_interpreter.play_stop_toggled_event == nil, "Transport was not toggled as we have just released the page button")
  end)

  it("should report grid-note intended for a certain sequencer position", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Press and hold sequencer position 0
    button_interpreter:handle_press({0,5,1})

    -- Press grid-notes for sequencer position 0
    button_interpreter:handle_press({2,0,1})
    assert.are.same({2,0}, captured_model.grid_note_into_sequencer_event)
    button_interpreter:handle_press({2,1,1})
    assert.are.same({2,1}, captured_model.grid_note_into_sequencer_event)
    button_interpreter:handle_press({2,2,1})
    assert.are.same({2,2}, captured_model.grid_note_into_sequencer_event)
    button_interpreter:handle_press({2,3,1})
    assert.are.same({2,3}, captured_model.grid_note_into_sequencer_event)
    button_interpreter:handle_press({2,4,1})
    assert.are.same({2,4}, captured_model.grid_note_into_sequencer_event)

    -- There should be no play events after grid_note_into_sequencer_event as grid_note_into_sequencer_events are for putting notes
    -- in the sequencer, not playing them
    assert(captured_model.grid_note_to_play_event == nil, "There should be no play events after grid_note_into_sequencer_event as grid_note_into_sequencer_events are for putting notes in the sequencer, not playing them")

    -- Release grid-note
    button_interpreter:handle_press({2,4,0})
    assert(captured_model.grid_note_into_sequencer_event == nil, "Grid-note should now be nil")
  end)

  it("should not repeat grid-note between on_change models", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    -- Press and hold sequencer position 0
    button_interpreter:handle_press({0,5,1})

    -- Press grid-notes for sequencer position 0
    button_interpreter:handle_press({2,0,1})
    assert.are.same({2,0}, captured_model.grid_note_into_sequencer_event)
    button_interpreter:handle_press({0,5,0})
    assert(captured_model.grid_note_into_sequencer_event == nil, "Grid-note should be nil")
  end)

  it("should forward grid-note events", function()
    local button_interpreter, captured_model = setup_button_interpreter()

    button_interpreter:handle_press({2,2,1})
    assert.are.same({2,2,1}, captured_model.grid_note_to_play_event)
    assert(captured_model.grid_note_into_sequencer_event == nil, "Grid-note toggle event should be nil")
    button_interpreter:handle_press({2,2,0})
    assert.are.same({2,2,0}, captured_model.grid_note_to_play_event)
    assert(captured_model.grid_note_into_sequencer_event == nil, "Grid-note toggle event should be nil")
  end)
end)