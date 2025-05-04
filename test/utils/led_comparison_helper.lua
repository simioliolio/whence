-- Helper function to check if a table contains a specific LED coordinate
local function table_contains_led(t, x, y)
  for _, led in ipairs(t) do
    if led[1] == x and led[2] == y then
      return true
    end
  end
  return false
end

local LedComparisonHelper = {}

-- Convert a multiline ASCII grid to an array of on LED coordinates
-- Grid format:
--   . represents an off LED
--   * represents an on LED
--   Each row should be 16 characters (for 16 columns)
--   There should be 8 rows (for 8 rows of LEDs)
-- Returns an array of {x,y} coordinates for each on LED
function LedComparisonHelper.grid_to_on_leds(grid)
  -- Extract just the dots and asterisks, ignoring all other characters
  local grid_stripped = grid:gsub("[^.*]", "")

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
-- Returns true if both arrays contain the same coordinates (order doesn't matter)
function LedComparisonHelper.compare_led_arrays(expected, actual)
  if #expected ~= #actual then
    return false, string.format("Expected %d LEDs but got %d", #expected, #actual)
  end

  -- Check if each expected LED exists in actual
  for _, expected_led in ipairs(expected) do
    if not table_contains_led(actual, expected_led[1], expected_led[2]) then
      return false, string.format("LED {%d,%d} not found in actual LEDs",
                                expected_led[1], expected_led[2])
    end
  end

  return true
end

return LedComparisonHelper