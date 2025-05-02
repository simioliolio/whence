local ButtonInterpreter = {}

function ButtonInterpreter.new()
  local self = {
    sequencer_page = 0,
    play_stop_toggled = nil,  -- Start as nil
    held_page_button = nil,  -- Track which page button is being held
    held_sequencer_position = nil,  -- Track which sequencer position is being held (0-31)
    grid_note_toggle = nil,  -- Track the current grid note being toggled
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
    if y == 6 and self.held_page_button ~= nil then
      if state == 1 then  -- Button press
        self.play_stop_toggled = not self.play_stop_toggled
        if self.listeners.on_change then
          self.listeners.on_change(self)
        end
      end
    -- Sequencer position rows (y = 5 or 6)
    elseif (y == 5 or y == 6) then
      local sequencer_position = x + (y == 6 and 16 or 0)  -- Map to 0-31 range

      if state == 1 then  -- Button press
        -- Track sequencer position when no page button is held
        self.held_sequencer_position = sequencer_position
      else  -- Button release
        if self.held_sequencer_position == sequencer_position then
          self.held_sequencer_position = nil
        end
      end
    end

    -- Grid notes (y = 1)
    if y == 1 and self.held_sequencer_position ~= nil then
      if state == 1 then  -- Button press
        self.grid_note_toggle = {x, y}
      else  -- Button release
        self.grid_note_toggle = nil
      end
      if self.listeners.on_change then
        self.listeners.on_change(self)
      end
    end
  end

  return self
end

return ButtonInterpreter
