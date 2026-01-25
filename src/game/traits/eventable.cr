module Traits
  module Eventable
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
  end
end
