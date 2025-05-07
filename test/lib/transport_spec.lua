require 'busted'
local Transport = require 'whence.lib.transport'

describe("Transport", function()
  it("should advance the sequencer if playing", function()
    local transport = Transport.new()
    local advanceCount = 0
    local advance = function()
      advanceCount = advanceCount + 1
    end
    transport.listeners.on_advance = advance
    transport:play()
    transport:clock()
    assert(advanceCount == 1)
  end)

  it("should not advance the sequencer if not playing", function()
    local transport = Transport.new()
    local advanceCount = 0
    local advance = function()
      advanceCount = advanceCount + 1
    end
    transport.listeners.on_advance = advance
    transport:clock()
    assert(advanceCount == 0)
  end)

  it("should play", function()
    local transport = Transport.new()
    transport:play()
    assert(transport.is_playing)
  end)

  it("should stop", function()
    local transport = Transport.new()
    transport:play()
    transport:stop()
    assert(not transport.is_playing)
  end)

  it("should stop advancing the sequencer when stopped", function()
    local transport = Transport.new()
    local advanceCount = 0
    local advance = function()
      advanceCount = advanceCount + 1
    end
    transport.listeners.on_advance = advance
    transport:play()
    transport:clock()
    assert(advanceCount == 1)
    transport:stop()
    transport:clock()
    assert(advanceCount == 1, "advanceCount should remain at 1 after stopping")
  end)
end)