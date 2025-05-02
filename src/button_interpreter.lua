local ButtonInterpreter = {}

function ButtonInterpreter.new()
  local self = {
    sequencer_page = 0,
    play_stop_toggled = nil,  -- Start as nil
    held_page_button = nil,  -- Track which page button is being held
    listeners = {
      on_change = nil -- set this to receive updates when the state changes
    }
  }

  function self:handle_press(button_data)
    local x, y, state = table.unpack(button_data)
    
    -- Page selection row (y = 7)
    if y == 7 then
      if state == 1 then  -- Button press
        self.held_page_button = x
        self.sequencer_page = x + 1
        if self.listeners.on_change then
          self.listeners.on_change(self)
        end
      else  -- Button release
        -- Only clear held_page_button if this was the currently held button
        if self.held_page_button == x then
          self.held_page_button = nil
        end
      end
    end

    -- Transport row (y = 6) when page button is held
    if y == 6 and state == 1 and self.held_page_button ~= nil then
      self.play_stop_toggled = not self.play_stop_toggled
      if self.listeners.on_change then
        self.listeners.on_change(self)
      end
    end
  end

  return self
end

return ButtonInterpreter
