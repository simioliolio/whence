require 'busted'
local LedProvider = require 'src.led_provider'
local EventModel = require 'src.event_model'
local comparison_helper = require 'test.utils.comparison_helper'
local ButtonInterpreter = require 'src.button_interpreter'

describe("LedProvider", function()
  it("should indicate current page", function()
    local led_provider = LedProvider.new()
    local event_model = EventModel.new()
    event_model.sequencer_page = 1
    local on_leds = led_provider:on_leds_for_event_model(event_model)

    -- show leds on 16x8 grid as a multiline string without spaces
    local expected_leds = [[
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
* . . . . . . . . . . . . . . .]]

    local expected_leds_stripped = expected_leds:gsub(" ", "")
    expected_leds_stripped = expected_leds_stripped:gsub("\n", "")

    -- translate the expected_leds to a table of tables {{x,y,state}, ...}
    local expected_on_leds_array = {}
    for y = 0, ButtonInterpreter.GRID_SIZE.Y - 1 do
      for x = 0, ButtonInterpreter.GRID_SIZE.X - 1 do
        -- +1 because the expected_leds_stripped is 1-indexed
        local pos = x + y * ButtonInterpreter.GRID_SIZE.X + 1
        local char = expected_leds_stripped:sub(pos, pos)
        if char == "*" then
          table.insert(expected_on_leds_array, {x, y})
        end
      end
    end

    -- Compare arrays by checking each coordinate pair
    assert(#expected_on_leds_array == #on_leds, string.format("Expected %d LEDs but got %d", #expected_on_leds_array, #on_leds))
    for i, expected_led in ipairs(expected_on_leds_array) do
      local actual_led = on_leds[i]
      assert(actual_led[1] == expected_led[1] and actual_led[2] == expected_led[2],
             string.format("LED %d mismatch: expected {%d,%d} but got {%d,%d}",
                         i, expected_led[1], expected_led[2], actual_led[1], actual_led[2]))
    end
  end)
end)