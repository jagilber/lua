-- Desc: A simple http get request function

local httpClient = {}

function httpClient.getHttp(url)
  -- get internet card
  local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

  -- get url from internet
  print('downloading: '..url)
  local req = card:request(url, "GET", "")
  local _, libdata = req:await()
  return libdata
end

function httpClient.postHttp(url, data)
  -- get internet card
  local card = computer.getPCIDevices(classes["FINInternetCard"])[1]

  -- get url from internet
  print('posting data to url: '..url)
  local req = card:request(url, "POST", data, "Content-Type", "text/json")
  local _, libdata = req:await()
  return libdata
end

return httpClient