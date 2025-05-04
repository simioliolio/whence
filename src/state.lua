local State = {}

function State.new()
  local self = {
    selected_page = 1,
    is_playing = false,
  }

  return self
end

return State
