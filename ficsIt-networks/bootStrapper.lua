-- Desc: 
--https://docs.ficsit.app/ficsit-networks/latest/lua/examples/InternetCard.html

local urls = {
  fileSystem = 'https://raw.githubusercontent.com/jagilber/lua/main/ficsIt-networks/fileSystem.lua',
  json = 'https://raw.githubusercontent.com/rxi/json.lua/master/json.lua',
  httpClient = 'https://raw.githubusercontent.com/jagilber/lua/main/ficsIt-networks/httpClient.lua',
  threading = 'https://raw.githubusercontent.com/jagilber/lua/main/ficsIt-networks/threading.lua',
  ficsItStorage = 'https://raw.githubusercontent.com/jagilber/lua/main/ficsIt-networks/ficsItStorage.lua'
}

local json = {}
local httpClient = {}
local ficsItStorage = {}

function main()

 json = loadRemoteLibrary(urls.json)
 httpClient = loadRemoteLibrary(urls.httpClient)
 ficsItStorage = loadRemoteLibrary(urls.ficsItStorage)
 print(#ficsItStorage.containers)

 print(json.encode(#ficsItStorage.containers))
end

function loadRemoteLibrary(url)
  -- get internet card
  local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

  -- get url from internet
  print('downloading: '..url)
  local req = card:request(url, "GET", "")
  local _, libdata = req:await()

  -- save url to filesystem
  filesystem.initFileSystem("/dev")
  filesystem.makeFileSystem("tmpfs", "tmp")
  filesystem.mount("/dev/tmp", "/")

  local localPath = url:match("^.+/(.+)$")
  --print('url data: '..libdata)
  print('saving to file: '..localPath)
  local file = filesystem.open(localPath, "w")
  file:write(libdata)
  file:close()
  -- load the library from the file system and use it
  return filesystem.doFile(localPath)
end

main()