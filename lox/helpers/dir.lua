-- lox/helpers/dir

-- Directory helper library stuff
Dir = {}

-- Scans a directory and returns a table of directory listings.
-- @directory [String] a directory to search
-- @suffix [String] an optional suffix to the files you want to grab.
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
