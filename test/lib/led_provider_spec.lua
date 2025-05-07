require 'busted'
local LedProvider = require 'whence.lib.led_provider'
local State = require 'whence.lib.state'
local LedComparisonHelper = require 'whence.test.utils.led_comparison_helper'
local ButtonInterpreter = require 'whence.lib.button_interpreter'

-- Helper function to check if a specific LED coordinate exists in the array
local function has_led(leds, x, y)
  for _, led in ipairs(leds) do
    if led[1] == x and led[2] == y then
      return true
    end
  end
  return false
end

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

    assert.is_true(has_led(on_leds, 0, 7))
    assert.equals(1, #on_leds)

    state.sequencer_page = 2
    on_leds = led_provider:leds(state)

    assert.is_true(has_led(on_leds, 1, 7))
    assert.equals(1, #on_leds)
  end)

  it("should show playback status when page button is held", function()
    local led_provider = LedProvider.new()
    local state = State.new()
    state.sequencer_page = 1
    state.held_page_button = 1
    state.is_playing = true
    local on_leds = led_provider:leds(state)

    -- Should have both the page indicator and transport LEDs
    assert.is_true(has_led(on_leds, 0, 7))
    assert.is_true(has_led(on_leds, 0, 6))
    assert.equals(2, #on_leds)

    state.is_playing = false
    on_leds = led_provider:leds(state)

    -- Should only have the page indicator LED
    assert.is_true(has_led(on_leds, 0, 7))
    assert.equals(1, #on_leds)
  end)
end)