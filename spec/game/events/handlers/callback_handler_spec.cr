require "../../../spec_helper"

describe Events::Handlers::CallbackHandler do
  describe "#handle" do
    it "executes the callback" do
      called = false
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      handler.handle(Events::KeyPressed.new)

      called.should be_true
    end

    it "returns true after handling" do
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { nil }
      )

      result = handler.handle(Events::KeyPressed.new)

      result.should be_true
    end

    it "receives the event as argument" do
      received_event = nil
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { received_event = event }
      )

      event = Events::KeyPressed.new
      handler.handle(event)

      received_event.should be(event)
    end
  end
end
