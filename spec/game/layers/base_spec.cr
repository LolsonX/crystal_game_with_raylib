require "../../spec_helper"

class TestableLayer < Layers::Base
  def test_subscribe_handler(handler : Events::Handlers::Base, event_type : Class)
    subscribe_handler(handler, event_type)
  end
end

describe Layers::Base do
  context "when initialized without a priority" do
    it "defaults priority to 0" do
      layer = Layers::Base.new

      layer.priority.should eq(0)
    end
  end

  context "when subscribing a handler through the layer" do
    it "uses the layer's priority for the subscription" do
      layer = TestableLayer.new(priority: 15)
      called = false
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      layer.test_subscribe_handler(handler, Events::KeyPressed)
      Events::Bus.instance.publish(Events::KeyPressed.new)

      called.should be_true
      Events::Bus.instance.unsubscribe(handler)
    end

    it "prevents duplicate priority registration for the same event type" do
      layer = TestableLayer.new(priority: 25)
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { nil }
      )

      layer.test_subscribe_handler(handler, Events::KeyPressed)

      another_handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { nil }
      )

      expect_raises(ArgumentError, "Priority 25 already registered for Events::KeyPressed") do
        Events::Bus.instance.subscribe(another_handler, Events::KeyPressed, priority: 25)
      end

      Events::Bus.instance.unsubscribe(handler)
    end
  end
end
