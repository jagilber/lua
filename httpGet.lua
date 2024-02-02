--https://docs.ficsit.app/ficsit-networks/latest/lua/examples/InternetCard.html

local urls = {
  'https://raw.githubusercontent.com/rxi/json.lua/master/json.lua',
  --'https://raw.githubusercontent.com/rxi/json.lua/master/json.lua'
}

local json = {}

function main()
 -- get internet card
 local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

 for url in values(urls) do
  -- get url from internet
  print('downloading: '..url)
  local req = card:request(url, "GET", "")
  local _, libdata = req:await()

  -- save url to filesystem
  filesystem.initFileSystem("/dev")
  filesystem.makeFileSystem("tmpfs", "tmp")
  filesystem.mount("/dev/tmp", "/")

  local localPath = url:match("^.+/(.+)$")
  print('url data: '..libdata)
  print('saving to file: '..localPath)
  local file = filesystem.open(localPath, "w")
  file:write(libdata)
  file:close()
  -- load the library from the file system and use it
  json = filesystem.doFile(localPath)
 end

--test
 local data = {
  somekey = "is stuff",
  otherkey = 42
 }
 print(json.encode(data))
end

function values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

main()

