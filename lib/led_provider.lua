local LedProvider = {}

function LedProvider.new()
  -- Try to be stateless
  local self = {}

  function self:leds(state)
    assert(state, "State is required")

    -- array of {x, y, state}
    local on_leds = {}

    -- Show current page in bottom row (y=7)
    -- Convert 1-based page number to 0-based x coordinate
    local x = state.sequencer_page - 1
    table.insert(on_leds, {x, 7})

    -- Show playback status in row above current page (y=6)
    if state.held_page_button then
      if state.is_playing then
        table.insert(on_leds, {0, 6})
      end
    end

    return on_leds
  end

  return self
end

return LedProvider
