local ButtonInterpreter = {}
local ButtonEvent = require 'whence.lib.button_event'

ButtonInterpreter.GRID_SIZE = {
  X = 16,
  Y = 8
}

ButtonInterpreter.MAX_BRIGHTNESS = 15

function ButtonInterpreter.new()
  local self = {
    event_model = ButtonEvent.new(),
    
    -- set this to receive updates when the state changes
    listeners = {
      on_change = nil
    }
  }

  function self:handle_press(button_data)
    local x, y, state = table.unpack(button_data)

    -- Grid notes (y = 0-4)
    self.grid_note_into_sequencer_event = nil
    self.grid_note_to_play_event = nil
    if y >= 0 and y <= 4 then
      if self.held_sequencer_position ~= nil then
        -- Handle grid notes for sequencer positions
        if state == 1 then  -- Button press
          self.grid_note_into_sequencer_event = {x, y}
        else  -- Button release
          self.grid_note_into_sequencer_event = nil
        end
      else
        -- Forward raw grid note events when not handling sequencer positions
        self.grid_note_to_play_event = {x, y, state}
      end
    end

    -- Transport row (y = 6) when page button is held
    self.play_stop_toggled_event = nil
    if y == 6 and self.held_page_button ~= nil then
      if state == 1 then  -- Button press
        self.play_stop_toggled_event = not self.play_stop_toggled_event
      end
    -- Sequencer position rows (y = 5 or 6)
    elseif (y == 5 or y == 6) then
      local sequencer_position = x + (y == 6 and ButtonInterpreter.GRID_SIZE.X or 0)  -- Map to full sequencer range

      if state == 1 then  -- Button press
        -- Track sequencer position when no page button is held
        self.held_sequencer_position = sequencer_position
      else  -- Button release
        if self.held_sequencer_position == sequencer_position then
          self.held_sequencer_position = nil
        end
      end
    end

    -- Page selection row (y = 7)
    if y == 7 then
      if state == 1 then  -- Button press
        self.held_page_button = x
        self.sequencer_page = x + 1
      else  -- Button release
        -- Only clear held_page_button if this was the currently held button
        if self.held_page_button == x then
          self.held_page_button = nil
        end
      end
    end

    -- Notify listeners of changes
    if self.listeners.on_change then
      self.listeners.on_change(self.event_model)
    end
  end

  return self
end

return ButtonInterpreter