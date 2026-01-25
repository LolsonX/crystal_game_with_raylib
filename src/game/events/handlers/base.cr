module Events
  module Handlers
    abstract class Base
      abstract def handle(event : Events::Base) : Bool
    end
  end
end
