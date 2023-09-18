-- lox/helpers/dir

-- Directory helper library stuff
Dir = {}

-- Scans a directory and returns a table of directory listings.
Dir.scandir = function(directory, suffix)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "'..directory..'"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()

  -- spit out directory entries
  -- print(tostring(#t) .. ' directory entries.')

  if suffix ~= nil then
    local nt, ind = {}, 0
    for _,v in ipairs(t) do
      ind = ind + 1
      print(tostring(ind)..' - '..tostring(v))
      if string.endswith(v, suffix) then
        -- print("it's true: "..v)
        nt[ind] = v
      end
    end
    -- print(tostring(#nt) .. ", final entries.")
    t = nt
  end

  return t
end

-- checks to see if a string ends with another string
-- doesn't coerce the string.
string.endswith = function(str, suffix)
  if suffix ~= nil then
    if string.sub(str, -(#suffix)) == suffix then
      return true
    end
  end
  -- suffix is nil so everything is false
  -- or, substring check didn't return true
  return false
end
