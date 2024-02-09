-- https://github.com/luarocks/luarocks/wiki/Download
-- https://www.lua.org/manual/5.4/manual.html
-- https://ficsit.app/mod/FicsItNetworks
-- https://docs.ficsit.app/ficsit-networks/latest/
-- https://devhints.io/lua

local thread = {
  threads = {},
  current = 1
 }
 
 function thread.create(func)
  print('creating thread')
  local t = {}
  t.co = coroutine.create(func)
  function t:stop()
   for i,th in pairs(thread.threads) do
    if th == t then
     table.remove(thread.threads, i)
    end
   end
  end
  print('inserting into threads list')
  table.insert(thread.threads, t)
  return t
 end
 
 function thread:run()
  while true do
   if #thread.threads < 1 then
    print('threads < 1, returning')
    return
   end
   if thread.current > #thread.threads then
    print('resetting current thread to 1')
    thread.current = 1
   end
   print('resuming thread:'..thread.current)
   print('thread status:'..coroutine.status(thread.threads[thread.current].co))
   coroutine.resume(thread.threads[thread.current].co,true)
   thread.current = thread.current + 1
  end
 end
 
 
 -- example
 
 function sleep()
  print('starting sleep')
  if event then
   print('pulling event')
   event.pull(0.0)
  elseif os then
   print('sleeping with os')
   os.execute("ping -n 2 localhost > NUL")
  end
  print('ending sleep')
 end
 
 function foo1()
  print('starting foo1')
  while true do
   sleep()
   print("doing foo1")
   coroutine.yield()
  end
 end
 
 function foo2()
  print('starting foo2')
  while true do
   sleep()
   print("doing foo2")
   coroutine.yield()
  end
 end
 
 local t1 = thread.create(foo1)
 local t2 = thread.create(foo2)
 
 thread.run()