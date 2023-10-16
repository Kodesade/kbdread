require 'device_input'

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
  
  def raw()
    @event
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

class KeyBind
  private_class_method :new
  def initialize(keys,callback)
    @keys = keys.map{|key| key.upcase}
    @callback = callback
  end
  
  def self.create(*keys,&callback)
    new(keys,callback)
  end
  
  def try(keys)
    if keys.keys.map{|key| key.upcase} == @keys
      @callback.call
      return true
    else 
      return false
    end
  end
end

class EventHandler
  private_class_method :new
  
  def initialize(log)
    @log = log
    @keybinds = []
    @keys = {}
  end
  
  def bind(keybind)
    @keybinds << keybind
    self
  end
  
  def give(event)
    if event.pressed?
      @keys[event.key] = event.raw
    else
      @keys.delete(event.key)
    end
    
    if @log and @keys.length > 0
      puts @keys.keys.join("+")
    end
    
    @keybinds.delete_if {|keybind| keybind.try(@keys)}
  end
  
  def self.create(log:false)
    if @instance then return @instance end
    @instance = new(log)
  end
end

class KeyListener
  private_class_method :new 
  def self.listen(idx,handler)
    if @instance then return @instance end
    @instance = new(idx,handler)
  end
  
  def initialize(idx,handler)
    Thread.new do
    File.open("/dev/input/event%s" % idx, 'r') do |dev|
    DeviceInput.read_loop(dev) do |event|
      begin 
        key = EventKey.new(event) 
      rescue BadEvent 
        next
      end
      handler.give(key)
    end
    end
    end
  end
end