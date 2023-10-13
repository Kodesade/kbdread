require 'device_input'

class BadEvent < StandardError
  attr_reader :event
  def initialize(event)
    @event = event
    super("Event has type %s" % event.type)
  end
end

class Key
  def initialize(event)
    if event.type != "EV_KEY"
      raise BadEvent.new(event)
    end
    @event = event
  end
  
  def key
    return @event.code
  end
  
  def pressed?
    if @event.data.value == 1 or @event.data.value == 2
      return true
    else
      return false
    end
  end
  
  def long_pressed?
    if @event.data.value == 2
      return true
    else
      return false
    end
  end
  
  def press_type
    @event.data.value
  end
  
  def to_s()
    key
  end
  
  def ==(other)
    key == other.key
  end
end

register={}

File.open('/dev/input/event%s' % ARGV[0],'r') do |dev|
  DeviceInput.read_loop(dev) do |event|
    begin
      key = Key.new(event)
    rescue BadEvent
      next
    end
    if key.pressed?
      register[key.key] = key.press_type
    else
      register.delete(key.key)
      next
    end
    puts register.keys.join("+")
  end
end