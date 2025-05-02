local LedComparisonHelper = {}

-- Convert a multiline ASCII grid to an array of on LED coordinates
-- Grid format:
--   . represents an off LED
--   * represents an on LED
--   Each row should be 16 characters (for 16 columns)
--   There should be 8 rows (for 8 rows of LEDs)
-- Returns an array of {x,y} coordinates for each on LED
function LedComparisonHelper.grid_to_on_leds(grid)
  local grid_stripped = grid:gsub(" ", "")
  grid_stripped = grid_stripped:gsub("\n", "")

  local on_leds = {}
  for y = 0, 7 do
    for x = 0, 15 do
      -- +1 because the grid_stripped is 1-indexed
      local pos = x + y * 16 + 1
      local char = grid_stripped:sub(pos, pos)
      if char == "*" then
        table.insert(on_leds, {x, y})
      end
    end
  end
  return on_leds
end

-- Compare two arrays of LED coordinates
-- Returns true if both arrays contain the same coordinates in the same order
function LedComparisonHelper.compare_led_arrays(expected, actual)
  if #expected ~= #actual then
    return false, string.format("Expected %d LEDs but got %d", #expected, #actual)
  end

  for i, expected_led in ipairs(expected) do
    local actual_led = actual[i]
    if actual_led[1] ~= expected_led[1] or actual_led[2] ~= expected_led[2] then
      return false, string.format("LED %d mismatch: expected {%d,%d} but got {%d,%d}",
                                i, expected_led[1], expected_led[2], actual_led[1], actual_led[2])
    end
  end

  return true
end

return LedComparisonHelper