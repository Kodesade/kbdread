require_relative 'reader'

lock = [true]
quitbind = KeyBind.create("LeftControl", "q"){ lock.replace([false]) }

handler = EventHandler.create(log: false)
device_event_id = 10
listener = KeyListener.listen(device_event_id,handler)
handler.bind(quitbind)

while lock[0]
  i ||= 0 
  puts "Time elapsed : %s" % i
  i += 1
  sleep 1
end

puts "End!"