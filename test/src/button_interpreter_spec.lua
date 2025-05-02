require 'busted'
local ButtonInterpreter = require 'src.button_interpreter'

describe("ButtonInterpreter", function()
  it("should set sequencer page numbers using row 7", function()
    local button_interpreter = ButtonInterpreter.new()
    local captured_model = nil
    local listener = function(model)
      captured_model = model
    end
    button_interpreter.listeners.on_page_change = listener

    -- Test pages 1-4 using buttons 0-3
    for x = 0, 3 do
      button_interpreter:handle_press({x,7,1})  -- Only test button press (state = 1)
      assert(captured_model.sequencer_page == x + 1, 
             string.format("Expected page %d when pressing button %d", x + 1, x))
    end
  end)
end)
