-- proxy.lua
--
-- Make a proxy table thing
--
t = {} -- original table (created somewhere)

-- keep a private access to the original table
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

-- Proxy the entire environment?
__Environment = {}
__EnvironmentMeta = {}
__EnvironmentINDEX = {}
__EnvironmentMeta = {
  __real_values = {},
  __proxy_names = {}, -- Array of proxied names, or keys that are proxied in this environment

  -- index returns the access of an item.
  __index = function (t,k)
    print("*access to element " .. tostring(k))
    if __EnvironmentMeta.__real_values[k] then
      return __EnvironmentMeta.__real_values[k]
    end
    return nil
    -- return t[__EnvironmentINDEX][k] -- access the original table
  end,

  __newindex = function (t,k,v)
    print("*update of element " .. tostring(k) ..
                         " to " .. tostring(v))
    __EnvironmentMeta.__real_values[k] = v  -- update the original table
  end
}

setmetatable(__Environment, __EnvironmentMeta)

-- _ENV = ____SecretEnvironment
_G = __Environment

old_load = load

function load(chunk, chunkname, mode, env)
  return old_load(chunk, chunkname, mode, __Environment)
end



-- So to proxy something, or to get a binding, I think, you like... reference it by `$name`. this returns the proxy object I think.
-- The proxy object is
