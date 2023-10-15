require_relative 'reader'

log = -> (events) {
  next if events.empty?
  puts events.keys.map{ _1.length == 1 ? _1.downcase : _1.capitalize }.join("+")
}

keyboard = KeyboardInput.new(10,_evproc: log)

keyboard.wait(*%w[leftcontrol leftshift q])
puts "{===== END =====}"