module Traits
  module Eventable
    def emit; end

    def publish_event(event : Events::Base)
      events << event
    end

    def events : Array(Events::Base)
      @events ||= Array(Events::Base).new
    end

    def poll_events(&)
      yield events
      events.clear
    end

    def process_events
      poll_events { |events| events.each { |event| Events::Bus.publish(event) } }
    end
  end
end
