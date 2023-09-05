-- proxy.lua
--
-- Make a proxy table thing
--
t = {} -- original tasble (created somewhere)

-- keep a private acces to the original table
local _t = t

-- create proxy
t = {}

-- create a metatable
local mt = {
  __index = function (t,k)
    print("*acess to element " .. tostring(k))
    return _t[k] -- access the original table
    end,

  __newindex = function (t,k,v)
    print("*update of element " .. tostring(k) ..
                          " to " .. tostring(v))
    _t[k] =  v -- update original table
  end
}
setmetatable(t, mt)



-- create private index
local index = {}

-- create metatable
local mt = {
  __index = function (t,k)
    print("*access to element " .. tostring(k))
    return t[index][k] -- access the original table
  end,

  __newindex = function (t,k,v)
    print("*update of element " .. tostring(k) ..
                         " to " .. tostring(v))
    t[index][k] = v  -- update the original table
  end
}

function track (t)
  local proxy = {}
  proxy[index] = t
  setmetatable(proxy, mt)
  return proxy
end
