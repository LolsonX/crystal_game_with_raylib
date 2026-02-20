require "../../spec_helper"

private class StoppingHandler < Events::Handlers::Base
  def handle(event : Events::Base) : Bool
    false
  end
end

describe Events::Bus do
  describe ".instance" do
    it "returns a singleton instance" do
      bus1 = Events::Bus.instance
      bus2 = Events::Bus.instance
      bus1.should be(bus2)
    end
  end

  describe "#subscribe and #publish" do
    it "calls handler when event is published" do
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

    it "dispatches handlers by priority (highest first)" do
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

    it "dispatches handlers in priority order regardless of subscription order" do
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

    it "stops handler chain when handler returns false (consumes event)" do
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

    it "high priority handler can consume event before low priority handlers" do
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

    it "does not call handler for different event type" do
      bus = Events::Bus.new
      called = false

      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { called = true }
      )

      bus.subscribe(handler, Events::KeyPressed, priority: 0)
      bus.publish(Events::CurrentTileChanged.new(tile: nil))

      called.should be_false
    end

    it "raises ArgumentError when duplicate priority registered for same event type" do
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

    it "allows same priority for different event types" do
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

  describe "#unsubscribe" do
    it "removes handler from all event types" do
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
