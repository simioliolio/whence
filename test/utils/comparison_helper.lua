return {
  simple_arrays_are_equal = function(arr1, arr2)
    -- 1. Quick check for identity (same array object)
    if arr1 == arr2 then
      return true
    end

    -- 2. Ensure both are actually tables
    if type(arr1) ~= 'table' or type(arr2) ~= 'table' then
      return false
    end

    -- 3. Compare lengths (# operator works reliably for arrays without holes)
    if #arr1 ~= #arr2 then
      return false
    end

    -- 4. Iterate and compare elements
    local len = #arr1 -- We know lengths are equal
    for i = 1, len do
      -- Use == for comparing elements (works for numbers, strings, booleans, nil)
      if arr1[i] ~= arr2[i] then
        return false -- Found a difference
      end
    end

    -- If we got here, they are equal
    return true
  end
}
