module Events
  abstract class Handler
    abstract def handle(event : Events::Base) : Bool
  end
end

