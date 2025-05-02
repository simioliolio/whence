-- Whence

-- Development notes:
-- norns lib types are only used in this file. Abstractions for grid, clock etc are used
-- under src/ (for unit testing)
--

g = grid.connect()
g.key = function(x,y,z) print(x,y,z) end
