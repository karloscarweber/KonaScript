-- lox/RuntimeError

-- constructor for new runtime Error object
RuntimeError = function (token, message)
  t = {
    ___type = "RuntimeError",
    token = token,
    message = message,
  }
  setmetatable(t, {
    __tostring=function(s, value)
      return  s.message .. " : "  ..  s.token.toString()
    end,
    type = function(s, value) return s.___type end,
  })
  return t
end

Error = {}
Error.Runtime()
