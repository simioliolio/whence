require 'busted'
local LedProvider = require 'src.led_provider'
local State = require 'src.state'
local comparison_helper = require 'test.utils.comparison_helper'
local LedComparisonHelper = require 'test.utils.led_comparison_helper'
local ButtonInterpreter = require 'src.button_interpreter'

describe("LedProvider", function()
  it("should indicate pages", function()
    local led_provider = LedProvider.new()
    local state = State.new()
    state.sequencer_page = 1
    local on_leds = led_provider:leds(state)

    local expected_leds = [[
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      * . . . . . . . . . . . . . . .]]

    local expected_on_leds = LedComparisonHelper.grid_to_on_leds(expected_leds)
    local success, error_message = LedComparisonHelper.compare_led_arrays(expected_on_leds, on_leds)
    assert(success, error_message)

    state.sequencer_page = 2
    local on_leds = led_provider:leds(state)

    local expected_leds = [[
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . * . . . . . . . . . . . . . .]]

    local expected_on_leds = LedComparisonHelper.grid_to_on_leds(expected_leds)
    local success, error_message = LedComparisonHelper.compare_led_arrays(expected_on_leds, on_leds)
    assert(success, error_message)
  end)

end)