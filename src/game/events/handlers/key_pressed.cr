module Events
  module Handlers
    class KeyPressed < Base
      def handle(event : Events::Base) : Bool
        true
      end
    end
  end
end
