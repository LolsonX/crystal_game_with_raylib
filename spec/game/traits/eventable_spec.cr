require "../../spec_helper"

class EventableTestClass
  include Traits::Eventable

  @events : Array(Events::Base)?
end

describe Traits::Eventable do
  describe "#events" do
    it "returns empty array initially" do
      obj = EventableTestClass.new
      obj.events.should be_empty
    end

    it "returns accumulated events" do
      obj = EventableTestClass.new
      event = Events::KeyPressed.new
      obj.publish_event(event)

      obj.events.size.should eq(1)
      obj.events.first.should be(event)
    end
  end

  describe "#publish_event" do
    it "adds event to events array" do
      obj = EventableTestClass.new
      event1 = Events::KeyPressed.new
      event2 = Events::KeyPressed.new

      obj.publish_event(event1)
      obj.publish_event(event2)

      obj.events.size.should eq(2)
    end
  end

  describe "#poll_events" do
    it "yields events to block" do
      obj = EventableTestClass.new
      event = Events::KeyPressed.new
      obj.publish_event(event)

      yielded_size = 0
      obj.poll_events { |events| yielded_size = events.size }

      yielded_size.should eq(1)
    end

    it "clears events after yielding" do
      obj = EventableTestClass.new
      obj.publish_event(Events::KeyPressed.new)

      obj.poll_events { |_| }

      obj.events.should be_empty
    end
  end

  describe "#process_events" do
    it "publishes events to the bus" do
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

    it "clears events after publishing" do
      obj = EventableTestClass.new
      obj.publish_event(Events::KeyPressed.new)

      obj.process_events

      obj.events.should be_empty
    end
  end
end
