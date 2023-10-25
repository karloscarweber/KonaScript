-- pixy.lua
-- Taken from: https://luajit.org/ext_ffi.html on the luajit website.

-- the following benchmark function was taken from lua-users group.
do
    local units = {
        ['seconds'] = 1,
        ['milliseconds'] = 1000,
        ['microseconds'] = 1000000,
        ['nanoseconds'] = 1000000000
    }

    -- function benchmark(unit, decPlaces, n, f, ...)
    function benchmark(unit, n, f, msg, ...)
        -- local unit = "seconds"
        local decPlaces = 3 -- comment out to revert
        local elapsed = 0
        local multiplier = units[unit]
        -- local multiplier = 1 -- seconds
        for i = 1, n do
            local now = os.clock()
            f(...)
            elapsed = elapsed + (os.clock() - now)
        end
        -- print(string.format('Benchmark results: %d function calls | %.'.. decPlaces ..'f %s elapsed | %.'.. decPlaces ..'f %s avg execution time.', n, elapsed * multiplier, unit, (elapsed / n) * multiplier, unit))
        local mem_KBytes = collectgarbage("count")
        if msg then
          print(string.format(msg .. ': %.'.. decPlaces .. 'f %s.' .. " MemoryUsed: %s KB", elapsed * multiplier, unit, mem_KBytes))
        else
          print(string.format('%.'.. decPlaces .. 'f %s.' .. " MemoryUsed: %s KB", elapsed * multiplier, unit, mem_KBytes))
        end

    end
end

-- local sin = math.sin
local box = {}
function test()
  for i = 1, 1000000 do
    local x = math.sin(i)
    box[i] = x
  end
end

benchmark('milliseconds', 100, test, 'inlined')

local sin = math.sin
local box2 = {}
function test2()
  for i = 1, 1000000 do
    local x = sin(i)
    box2[i] = x
  end
end

benchmark('milliseconds', 100, test2, 'localed') -- Benchmark results: 500 function calls | 254.96 milliseconds elapsed | 0.51 milliseconds avg execution time.

-- This experiment is meant to test speed and memory usage between two different
-- types of calls The first, unoptimized without adding a reference to a library
--  function inside of a local then referenced as an upvalue inside of an
-- executing function. The second is to test what referencing that upvalue would
-- do to performance.

-- localizing functions increases the speed considerably, like by a lot. Also
-- it's clear that LuaJit is far faster than Lua in these tests. 10 to 50 times
-- faster across all tests. So use LuaJIT.
