require 'device_input'

LOCK=Thread::Mutex.new

class BadEvent < StandardError
  attr_reader :event
  def initialize(event)
    @event = event
    super("Event has type %s" % event.type)
  end
end

class EventKey
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

class KeyboardInput
  
  def initialize(i,_evproc:nil)
    @main_thread = Thread.current
    @event_file = "/dev/input/event%s" % i
    @events = {}
    @wait_list = []
    @handler = event_handler()
    @evproc = _evproc
  end
  
  def wait(*keys)
    keys.map!{|key| key.upcase}
    LOCK.synchronize { @wait_list = keys }
    sleep
  end
  
  private
  
  def event_handler()
    Thread.new do
      File.open(@event_file,'r') do |dev|
        DeviceInput.read_loop(dev) do |event|
          begin
            key = EventKey.new(event)
          rescue BadEvent
            next
          end
          
          if key.pressed?
            @events[key.key.upcase] = key.press_type
          else
            @events.delete(key.key.upcase)
          end
          if @evproc and @evproc.respond_to? :call
            @evproc.call(@events)
          end
          LOCK.synchronize {
            @main_thread.wakeup if @wait_list.all?{|key| @events.keys.include?(key) }
          }
        end
      end
    end
  end
end