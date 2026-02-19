module Events
  module Handlers
    abstract class Base
      abstract def handle(event : Events::Base) : Bool
    end

    class CallbackHandler < Base
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
