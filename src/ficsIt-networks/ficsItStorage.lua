-- Desc: A simple http get request function

local ficsItStorage = {}

--function main()
ficsItStorage.splitters = {}  --component.proxy(component.findComponent("splitter"))       --"Storage_in.splitter.01"))
ficsItStorage.containers = {} --component.proxy(component.findComponent("storage"))
ficsItStorage.connectors = {}
ficsItStorage.containerBuffer = {}
ficsItStorage.containerInvs = {}
ficsItStorage.splitterContainers = {}
ficsItStorage.containerMax = {}
--end

function ficsItStorage.split(inputstr, sep)
   print('splitting: ' .. inputstr)
   if sep == nil then
      sep = "%s"
   end
   local t = {}
   for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
      table.insert(t, str)
   end
   return t
end

function ficsItStorage.findSplitter(container)
   local id = ficsItStorage.split(container.nick, " ")[2]
   for _, splitter in pairs(ficsItStorage.splitters) do
      print('checking splitter: ' .. splitter.nick)
      if ficsItStorage.split(splitter.nick, " ")[2] == id then
         print('using splitter.nick: ' .. splitter.nick)
         return splitter
      end
   end
   print("not found")
end

function ficsItStorage.init()
   ficsItStorage.containers = component.proxy(component.findComponent("storage"))
   ficsItStorage.splitters = component.proxy(component.findComponent("splitter"))
   print('splitters: ' .. #ficsItStorage.splitters)
   print('splitter: ' .. ficsItStorage.splitters[1].internalName)
   print('containers: ' .. #ficsItStorage.containers)
   print('container: ' .. ficsItStorage.containers[1].internalName)

   for _, container in pairs(ficsItStorage.containers) do
      local connector = container:getFactoryConnectors()[1]
      print('listening on connector: ' .. connector.internalName)
      if not ficsItStorage.connectors[connector] then
         print('adding connector: ' .. connector.internalName)
      end
      print('setting connector: ' .. connector.internalName .. ' to container: ' .. container.nick)
      ficsItStorage.connectors[connector] = container
      event.listen(connector)

      ficsItStorage.containerBuffer[container] = 0
      ficsItStorage.containerInvs[container] = container:getInventories()[1]
      ficsItStorage.splitterContainers[ficsItStorage.findSplitter(container)] = container
      print('containerMax: ' .. ficsItStorage.split(container.nick)[3])
      ficsItStorage.containerMax[container] = tonumber(ficsItStorage.split(container.nick)[3])
   end
end

function ficsItStorage:run()
   while true do
      for _, splitter in pairs(ficsItStorage.splitters) do
         if splitter:getInput() then
            local container = ficsItStorage.splitterContainers[splitter]
            print('splitter: ' .. splitter.nick .. ' has input')
            local containerBuffer = ficsItStorage.containerBuffer[container]
            local containerInv = ficsItStorage.containerInvs[container].ItemCount
            local containerMax = ficsItStorage.containerMax[container]
            print('containerBuffer: ' .. containerBuffer)
            print('containerInv: ' .. containerInv)
            print('containerMax: ' .. containerMax)
            if containerBuffer + containerInv < containerMax then
               if splitter:transferItem(0) then
                  print('transfering item')
                  ficsItStorage.containerBuffer[container] = containerBuffer + 1
               end
            else
               print('splitter: ' .. splitter.nick .. ' has input, but container is full')
               splitter:transferItem(1)
            end
         end
      end
   end
end

--main()
return ficsItStorage
