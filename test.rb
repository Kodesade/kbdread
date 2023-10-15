require_relative 'reader'

log = -> (events) {
  next if events.empty?
  puts events.keys.map{ _1.length == 1 ? _1.downcase : _1.capitalize }.join("+")
}
device_event_id = 10
keyboard = KeyboardInput.new(device_event_id,_evproc: log)

keyboard.wait(*%w[leftcontrol leftshift q])
puts "{===== END =====}"