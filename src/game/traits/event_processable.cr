module Traits
  module EventProcessable
    include Eventable

    def process_events
      poll_events { |events| events.each { |event| Events::Bus.publish(event) } }
    end
  end
end
