-- Desc: A simple http get request function

local ficsItStorage = {}

function main()
   ficsItStorage.splitters = component.proxy(component.findComponent("Splitter"))
   print('splitters: '..#ficsItStorage.splitters)
   ficsItStorage.containers = component.proxy(component.findComponent("Storage"))
   print('containers: '..#ficsItStorage.containers)
   ficsItStorage.connectors = {}
   ficsItStorage.containerBuffer = {}
   ficsItStorage.containerInvs = {}
   ficsItStorage.splitterContainers = {}
   ficsItStorage.containerMax = {}
end

function ficsItStorage.split(inputstr, sep)
 print('splitting: '..inputstr)
 if sep == nil then
  sep = "%s"
 end
 local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
   table.insert(t, str)
  end
 return t
end

function ficsItStorage.findSplitter(container)
 local id = ficsItStorage.split(container.nick, " ")[2]
 for _, splitter in pairs(ficsItStorage.splitters) do
   print('checking splitter: '..splitter.nick)
  if ficsItStorage.split(splitter.nick, " ")[2] == id then
   print('using splitter.nick: '..splitter.nick)
   return splitter
  end
 end
 print("not found")
end

for _,container in pairs(ficsItStorage.containers) do
 local connector = container:getFactoryConnectors()[1]
 print('listening on connector: '..connector)
 if not ficsItStorage.connectors[connector] then
  print('adding connector: '..connector)
 end
 print('setting connector: '..connector..' to container: '..container.nick)
 ficsItStorage.connectors[connector] = container
 event.listen(connector)

 ficsItStorage.containerBuffer[container] = 0
 ficsItStorage.containerInvs[container] = container:getInventories()[1]
 ficsItStorage.splitterContainers[ficsItStorage.findSplitter(container)] = container
 ficsItStorage.containerMax[container] = tonumber(ficsItStorage.split(container.nick)[3])
end

while true do
 e,sender = event.pull(0)
 if e == "ItemTransfer" then
  for connector, container in pairs(ficsItStorage.connectors) do
   if connector == sender and ficsItStorage.containerBuffer[container] then
      ficsItStorage.containerBuffer[container] = ficsItStorage.containerBuffer[container] - 1
   end
  end
 else
  for _,splitter in pairs(ficsItStorage.splitters) do
   if splitter:getInput() then
    local container = ficsItStorage.splitterContainers[splitter]
    if ficsItStorage.containerBuffer[container] + ficsItStorage.containerInvs[container].ItemCount < ficsItStorage.containerMax[container] then
     if splitter:transferItem(0) then
      ficsItStorage.containerBuffer[container] = ficsItStorage.containerBuffer[container] + 1
     end
    else
     splitter:transferItem(1)
    end
   end
  end
 end
end

main()
return ficsItStorage