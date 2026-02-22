require "../../spec_helper"

private class StoppingHandler < Events::Handlers::Base
  def handle(event : Events::Base) : Bool
    false
  end
end

describe Events::Bus do
  context "when a handler is subscribed to an event type" do
    it "invokes the handler when that event is published" do
      bus = Events::Bus.new
      called = false

      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(handler, Events::KeyPressed, priority: 0)
      bus.publish(Events::KeyPressed.new)

      called.should be_true
    end

    it "uses default priority of 0 when not specified" do
      bus = Events::Bus.new
      called = false

      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(handler, Events::KeyPressed)
      bus.publish(Events::KeyPressed.new)

      called.should be_true
    end

    it "does not invoke the handler for different event types" do
      bus = Events::Bus.new
      called = false

      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(handler, Events::KeyPressed, priority: 0)
      bus.publish(Events::CurrentTileChanged.new(tile: nil))

      called.should be_false
    end
  end

  context "when multiple handlers subscribe with different priorities" do
    it "dispatches highest priority first" do
      bus = Events::Bus.new
      order = [] of Int32

      low_handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 1 }
      )
      high_handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 2 }
      )
      medium_handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 3 }
      )

      bus.subscribe(low_handler, Events::KeyPressed, priority: 5)
      bus.subscribe(high_handler, Events::KeyPressed, priority: 20)
      bus.subscribe(medium_handler, Events::KeyPressed, priority: 10)
      bus.publish(Events::KeyPressed.new)

      order.should eq([2, 3, 1])
    end

    it "maintains priority order regardless of subscription order" do
      bus = Events::Bus.new
      order = [] of Int32

      handler_20 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 20 }
      )
      handler_10 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 10 }
      )
      handler_5 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { order << 5 }
      )

      bus.subscribe(handler_5, Events::KeyPressed, priority: 5)
      bus.subscribe(handler_20, Events::KeyPressed, priority: 20)
      bus.subscribe(handler_10, Events::KeyPressed, priority: 10)
      bus.publish(Events::KeyPressed.new)

      order.should eq([20, 10, 5])
    end
  end

  context "when a handler returns false to consume the event" do
    it "stops the handler chain" do
      bus = Events::Bus.new
      called = false

      stopping_handler = StoppingHandler.new
      handler2 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(stopping_handler, Events::KeyPressed, priority: 20)
      bus.subscribe(handler2, Events::KeyPressed, priority: 10)
      bus.publish(Events::KeyPressed.new)

      called.should be_false
    end

    it "prevents lower priority handlers from executing" do
      bus = Events::Bus.new
      low_called = false

      high_stopping = StoppingHandler.new
      low_handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { low_called = true }
      )

      bus.subscribe(low_handler, Events::KeyPressed, priority: 5)
      bus.subscribe(high_stopping, Events::KeyPressed, priority: 20)
      bus.publish(Events::KeyPressed.new)

      low_called.should be_false
    end
  end

  context "when subscribing with a duplicate priority for the same event type" do
    it "raises ArgumentError" do
      bus = Events::Bus.new

      handler1 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { nil }
      )
      handler2 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { nil }
      )

      bus.subscribe(handler1, Events::KeyPressed, priority: 10)

      expect_raises(ArgumentError, "Priority 10 already registered for Events::KeyPressed") do
        bus.subscribe(handler2, Events::KeyPressed, priority: 10)
      end
    end
  end

  context "when the same priority is used for different event types" do
    it "allows both subscriptions" do
      bus = Events::Bus.new
      called_key = false
      called_tile = false

      handler1 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called_key = true }
      )
      handler2 = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called_tile = true }
      )

      bus.subscribe(handler1, Events::KeyPressed, priority: 10)
      bus.subscribe(handler2, Events::CurrentTileChanged, priority: 10)

      bus.publish(Events::KeyPressed.new)
      bus.publish(Events::CurrentTileChanged.new(tile: nil))

      called_key.should be_true
      called_tile.should be_true
    end
  end

  context "when a handler is unsubscribed" do
    it "removes the handler from all event types" do
      bus = Events::Bus.new
      called = false

      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(handler, Events::KeyPressed, priority: 0)
      bus.unsubscribe(handler)
      bus.publish(Events::KeyPressed.new)

      called.should be_false
    end
  end
end
