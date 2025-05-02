require 'busted'
local ButtonInterpreter = require 'src.button_interpreter'

describe("ButtonInterpreter", function()
  it("should set sequencer page numbers using row 7", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener

    -- Test pages 1-4 using buttons 0-3
    for x = 0, 3 do
      button_interpreter:handle_press({x,7,1})  -- Only test button press (state = 1)
      assert(captured_model.sequencer_page == x + 1, 
             string.format("Expected page %d when pressing button %d", x + 1, x))
    end
  end)

  it("should interpret row 6 as transport when page button held", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener

    -- Initial state
    assert(button_interpreter.play_stop_toggled == nil, "Initial state should be false")

    -- Press page button
    button_interpreter:handle_press({0,7,1})
    assert(button_interpreter.held_page_button == 0, "Page button should be held")

    -- Press transport button
    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled == true, "Transport should be toggled")
  end)

  it("should interpret row 6 as transport when page buttons held", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener

    -- A slightly more complex test involving when the page button is released

    -- Initial state
    assert(button_interpreter.play_stop_toggled == nil, "Initial state should be false")

    -- Press page button
    button_interpreter:handle_press({0,7,1})
    assert(button_interpreter.held_page_button == 0, "Page button 0 should be held")

    button_interpreter:handle_press({1,7,1})
    button_interpreter:handle_press({0,7,0})
    assert(button_interpreter.held_page_button == 1, "Page button 1 should be held")

    -- Press transport button
    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled == true, "Transport should be toggled")
    button_interpreter:handle_press({1,7,0})
    assert(button_interpreter.held_page_button == nil, "Page button 1 should be held")
    button_interpreter:handle_press({0,6,1})
  end)

  it("should not toggle transport when page button released", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener

    -- Initial state
    assert(button_interpreter.play_stop_toggled == nil, "Initial state should be false")

    button_interpreter:handle_press({0,6,1})
    assert(button_interpreter.play_stop_toggled == nil, "Transport should not be toggled as we are not holding a page button")
    button_interpreter:handle_press({0,6,0})
    assert(button_interpreter.play_stop_toggled == nil, "Transport should not be toggled as we are not holding a page button")
  end)

  it("should not play when column 1 button is pressed when page button is held", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_change = listener

    -- Press page button
    button_interpreter:handle_press({0,7,1})

    -- Press column 1 button
    button_interpreter:handle_press({0,1,1})
    assert(button_interpreter.play_stop_toggled == nil, "Transport should not be toggled as we are not pressing the transport button")
  end)

end)