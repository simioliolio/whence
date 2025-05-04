local LedProvider = {}

function LedProvider.new()
  -- Try to be stateless
  local self = {}

  function self:on_leds_for_event_model(event_model)
    -- array of {x, y, state}
    local on_leds = {}

    -- Show current page in bottom row (y=7)
    local x = event_model.sequencer_page - 1
    table.insert(on_leds, {x, 7})

    return on_leds
  end

  return self
end

return LedProvider
