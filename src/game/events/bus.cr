module Events
  class Bus
    record HandlerEntry, handler : Handlers::Base, priority : Int32

    @@instance : Bus?

    def self.instance : Bus
      @@instance ||= new
    end

    def self.reset
      @@instance = nil
    end

    def self.publish(event : Events::Base)
      instance.publish(event)
    end

    def self.subscribe(handler : Handlers::Base, event_type : Class, priority : Int32 = 0)
      instance.subscribe(handler, event_type, priority)
    end

    def self.unsubscribe(handler : Handlers::Base)
      instance.unsubscribe(handler)
    end

    def initialize
      @handlers = Hash(String, Array(HandlerEntry)).new { |hsh, key| hsh[key] = [] of HandlerEntry }
    end

    def publish(event : Events::Base)
      if entries = @handlers[event.class.name]?
        entries.each { |entry| break unless entry.handler.handle(event) }
      end
    end

    def subscribe(handler : Handlers::Base, event_type : Class, priority : Int32 = 0)
      entries = @handlers[event_type.name]

      if entries.any? { |entry| entry.priority == priority }
        raise ArgumentError.new("Priority #{priority} already registered for #{event_type.name}")
      end

      entries << HandlerEntry.new(handler: handler, priority: priority)
      entries.sort_by! { |entry| -entry.priority }
    end

    def unsubscribe(handler : Handlers::Base)
      @handlers.each_value &.reject! { |entry| entry.handler == handler }
    end
  end
end
