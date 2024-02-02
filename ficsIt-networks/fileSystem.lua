-- Desc: A simple http get request function

local fileSystem = {}

function fileSystem.saveToFile(data, fileName)
   -- save url to filesystem
   filesystem.initFileSystem("/dev")
   filesystem.makeFileSystem("tmpfs", "tmp")
   filesystem.mount("/dev/tmp", "/")
 
   --print('url data: '..data)
   print('saving to file: '..fileName)
   local file = filesystem.open(fileName, "w")
   file:write(data)
   file:close()
   -- load the library from the file system and use it
   return filesystem.doFile(fileName)
end
  
  return fileSystem