module Events
  class Bus
    @@instance : Bus?

    def self.instance : Bus
      @@instance ||= new
    end

    def self.publish(event : Events::Base)
      instance.publish(event)
    end

    def self.subscribe(handler : Events::Handler, event_type : Class)
      instance.subscribe(handler, event_type)
    end

    def self.unsubscribe(handler : Events::Handler)
      instance.unsubscribe(handler)
    end

    def initialize
      @handlers = Hash(String, Array(Events::Handler)).new { |hsh, key| hsh[key] = [] of Events::Handler }
    end

    def publish(event : Events::Base)
      if handlers = @handlers[event.class.name]
        handlers.each { |handler| return unless handler.handle(event) }
      end
    end

    def subscribe(handler : Events::Handler, event_type : Class)
      @handlers[event_type.name] << handler
    end

    def unsubscribe(handler : Events::Handler)
      @handlers.values.each &.delete(handler)
    end
  end
end
