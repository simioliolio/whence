local ButtonInterpreter = {}

function ButtonInterpreter.new()
  local self = {
    sequencer_page = 0,
    listeners = {
      on_page_change = nil
    }
  }

  function self:handle_press(button_data)
    local x, y, state = table.unpack(button_data)
    
    -- Process button presses (state = 1)
    if state == 1 then
      -- Handle page selection using row 7 (y = 7)
      if y == 7 then
        self.sequencer_page = x + 1  -- Adding 1 since Lua arrays are 1-based
        if self.listeners.on_page_change then
          self.listeners.on_page_change(self)
        end
      end
    end
  end

  return self
end

return ButtonInterpreter
