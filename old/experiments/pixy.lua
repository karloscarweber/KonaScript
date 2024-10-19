-- pixy.lua
-- Taken from: https://luajit.org/ext_ffi.html on the luajit website.

-- the following benchmark function was taken from lua-users group.
do
    -- local units = {
    --     ['seconds'] = 1,
    --     ['milliseconds'] = 1000,
    --     ['microseconds'] = 1000000,
    --     ['nanoseconds'] = 1000000000
    -- }

    -- function benchmark(unit, decPlaces, n, f, ...)
    function benchmark(n, f, ...)
        local unit = "seconds"
        local decPlaces = 3 -- comment out to revert
        local elapsed = 0
        -- local multiplier = units[unit]
        local multiplier = 1 -- seconds
        for i = 1, n do
            local now = os.clock()
            f(...)
            elapsed = elapsed + (os.clock() - now)
        end
        -- print(string.format('Benchmark results: %d function calls | %.'.. decPlaces ..'f %s elapsed | %.'.. decPlaces ..'f %s avg execution time.', n, elapsed * multiplier, unit, (elapsed / n) * multiplier, unit))
        print(string.format('%.'.. decPlaces .. 'f %s', elapsed * multiplier, unit))
    end
end

local ffi = require("ffi")
ffi.cdef[[
typedef struct { int8_t red, green, blue, alpha; } rgba_pixel;
]]

local function pixel(n)
  return ffi.new("rgba_pixel[?]", n)
end

local function image_ramp_green(n)
  local img = pixel(n)
  local f = 255/(n-1)
  for i=0,n-1 do
    img[i].green = i*f
    img[i].alpha = 255
  end
  return img
end

local function image_to_gray(img, n)
  for i=0,n-1 do
    local y = 0.3*img[i].red + 0.59*img[i].green + 0.11*img[i].blue
    img[i].red = y; img[i].green = y; img[i].blue = y
  end
end

function test()
  local N = 400*400
  local img = image_ramp_green(N)
  for i=1,1000 do
    image_to_gray(img, N)
  end
end

benchmark(1, test) -- Benchmark results: 500 function calls | 254.96 milliseconds elapsed | 0.51 milliseconds avg execution time.
