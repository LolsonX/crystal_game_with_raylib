require "../../spec_helper"

class EventableTestClass
  include Traits::Eventable

  @events : Array(Events::Base)?
end

describe Traits::Eventable do
  context "when polling events" do
    it "yields all events to the block and clears the array" do
      obj = EventableTestClass.new
      event = Events::KeyPressed.new
      obj.publish_event(event)

      yielded_size = 0
      obj.poll_events { |events| yielded_size = events.size }

      yielded_size.should eq(1)
      obj.events.should be_empty
    end
  end

  context "when processing events" do
    it "publishes events to the global event bus" do
      obj = EventableTestClass.new
      event = Events::KeyPressed.new
      obj.publish_event(event)

      received = false
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_e : Events::Base) { received = true }
      )

      Events::Bus.instance.subscribe(handler, Events::KeyPressed)
      obj.process_events
      Events::Bus.instance.unsubscribe(handler)

      received.should be_true
    end

    it "clears the events array after publishing" do
      obj = EventableTestClass.new
      obj.publish_event(Events::KeyPressed.new)

      obj.process_events

      obj.events.should be_empty
    end
  end
end
