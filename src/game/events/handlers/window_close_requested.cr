module Events
  module Handlers
    class WindowCloseRequested < Base
      def initialize(@game : Game)
      end

      def handle(event : Events::Base) : Bool
        @game.window_close_requested = true
        true
      end
    end
  end
end
