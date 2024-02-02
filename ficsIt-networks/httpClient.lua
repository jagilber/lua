-- Desc: A simple http get request function
local function getHttp(url)
  -- get internet card
  local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

  -- get url from internet
  print('downloading: '..url)
  local req = card:request(url, "GET", "")
  local _, libdata = req:await()
  return libdata
end

local function postHttp(url, data)
  -- get internet card
  local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

  -- get url from internet
  print('posting data to url: '..url)
  local req = card:request(url, "POST", data)
  local _, libdata = req:await()
  return libdata
end