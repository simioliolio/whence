local Transport = {}

function Transport.new()
  local self = {
    listeners = {
      on_advance = nil
    },
    is_playing = false
  }

  function self:clock()
    if self.is_playing and self.listeners.on_advance then
      self.listeners.on_advance()
    end
  end

  function self:play()
    self.is_playing = true
  end

  function self:stop()
    self.is_playing = false
  end

  return self
end

return Transport
