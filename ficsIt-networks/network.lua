-- Desc: A simple http get request function

local network = {}

function network.init()
   network.comp = component.proxy(component.findComponent("machine")[1])
   local fields = {}
   for key, value in string.gmatch(network.comp.nick, "(%w+)=([^%s]+)") do
      fields[key] = value
   end
   -- if there is now a component with the nick "machine setting1=42 setting2=meep"
   -- then the fields table will look like {"setting1"="42", "setting2"="meep"}
   network.comp.fields = fields
   network.isenabled = true
   return network.comp
end

function network.id()
   if not network.isenabled then
      print("network is not enabled")
      return nil
   end
   print('returning network id: '..network.comp.id) -- prints the ID of the component with a nick group "machine"
   return network.comp.id
end

function network.receive()

end

function network.send()

end

return network
