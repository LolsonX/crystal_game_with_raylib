module Layers
  class Base
    getter priority : Int32

    def initialize(@priority : Int32 = 0)
    end

    protected def subscribe_handler(handler : Events::Handlers::Base, event_type : Class)
      Events::Bus.subscribe(handler, event_type, priority: @priority)
    end
  end
end
