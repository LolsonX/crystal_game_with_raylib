module Events
  class TestHandler < Handler
    def handle(event : Events::Base) : Bool
      puts "EVENT #{event} handled"
      false
    end
  end
end
