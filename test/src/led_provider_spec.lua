require 'busted'
local LedProvider = require 'src.led_provider'
local State = require 'src.state'
local comparison_helper = require 'test.utils.comparison_helper'
local LedComparisonHelper = require 'test.utils.led_comparison_helper'
local ButtonInterpreter = require 'src.button_interpreter'

describe("LedProvider", function()
  it("should require state", function()
    local led_provider = LedProvider.new()
    assert.has_error(function()
      led_provider:leds(nil)
    end, "State is required")
  end)

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

  it("should show playback status when page button is held", function()
    local led_provider = LedProvider.new()
    local state = State.new()
    state.sequencer_page = 1
    state.held_page_button = 1
    state.is_playing = true
    local on_leds = led_provider:leds(state)

    local expected_leds = [[
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      . . . . . . . . . . . . . . . .
      * . . . . . . . . . . . . . . .
      * . . . . . . . . . . . . . . .]]

    local expected_on_leds = LedComparisonHelper.grid_to_on_leds(expected_leds)
    local success, error_message = LedComparisonHelper.compare_led_arrays(expected_on_leds, on_leds)
    assert(success, error_message)

    state.is_playing = false
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

  end)
end)