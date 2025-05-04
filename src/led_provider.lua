local LedProvider = {}

function LedProvider.new()
  -- Try to be stateless
  local self = {}

  function self:leds(state)
    assert(state, "State is required")

    -- array of {x, y, state}
    local on_leds = {}

    -- Show current page in bottom row (y=7)
    if state and state.sequencer_page then
      -- Convert 1-based page number to 0-based x coordinate
      local x = state.sequencer_page - 1
      table.insert(on_leds, {x, 7})
    end

    return on_leds
  end

  return self
end

return LedProvider
