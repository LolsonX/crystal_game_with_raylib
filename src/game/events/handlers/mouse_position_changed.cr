module Events
  module Handlers
    class MousePositionChanged < Base
      getter handler : Proc(Events::Base, Nil)

      def initialize(@handler : Proc(Events::Base, Nil))
      end

      def handle(event : Events::Base) : Bool
        handler.call(event)
        true
      end
    end
  end
end
