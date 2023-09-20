-- lox/helpers/dir
require 'lox/helpers/string'

-- Directory helper library stuff
Dir = {}

-- Scans a directory and returns a table of directory listings.
-- @directory [String] a directory to search
-- @prefix [String] an optional prefix to the files you want to grab.
Dir.filter = function(directory, prefix, suffix)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "'..directory..'"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()

  -- check that the suffix is .lua
  if not suffix then suffix = ".lua" end
  local st = {}
  for _,v in ipairs(t) do
    if string.endswith(v, suffix) then
      table.insert(st,v)
    end
  end
  t = st

  if prefix ~= nil then
    print(tostring(prefix))
    local nt = {}
    for ind,v in ipairs(t) do
      print(tostring(ind)..' - '..tostring(v))
      if string.isValidFilename(v) and string.beginswith(v, prefix) then
        table.insert(nt,v)
      end
    end
    t = nt
  end

  -- add directory prefix
  local fp = {}
  for _,f in ipairs(t) do
    table.insert(fp, directory .. "/" .. f)
  end

  return fp
end
