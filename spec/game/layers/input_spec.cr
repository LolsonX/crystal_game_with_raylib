require "../../spec_helper"

module CrystalRaylib
  module Input
    @@mock_mouse_position : Types::Vector2 = Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)

    def self.mock_mouse_position=(pos : Types::Vector2)
      @@mock_mouse_position = pos
    end

    def self.mouse_position : Types::Vector2
      @@mock_mouse_position
    end
  end
end

require "../../../src/game/layers/input"

describe Layers::Input do
  context "when initialized with a camera" do
    it "stores the camera and priority" do
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      input = Layers::Input.new(camera: camera, priority: 20)

      input.priority.should eq(20)
    end
  end

  context "when mouse position changes significantly" do
    it "publishes MousePositionChanged event" do
      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)

      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      input = Layers::Input.new(camera: camera)

      received_event = nil
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) {
          if event.is_a?(Events::MousePositionChanged)
            received_event = event
          end
        }
      )
      Events::Bus.instance.subscribe(handler, Events::MousePositionChanged, priority: 0)

      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32)
      input.emit
      input.process_events

      Events::Bus.instance.unsubscribe(handler)

      received_event.should_not be_nil
    end

    it "updates the internal mouse position" do
      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)

      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      input = Layers::Input.new(camera: camera)
      initial_pos = input.mouse_position

      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 150.0_f32, y: 250.0_f32)
      input.emit

      input.mouse_position.should_not eq(initial_pos)
    end
  end

  context "when mouse position changes within EPSILON tolerance" do
    it "does not publish MousePositionChanged event" do
      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32)

      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      input = Layers::Input.new(camera: camera)

      event_count = 0
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { event_count += 1 }
      )
      Events::Bus.instance.subscribe(handler, Events::MousePositionChanged, priority: 0)

      CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 100.0001_f32, y: 200.0_f32)
      input.emit
      input.process_events

      Events::Bus.instance.unsubscribe(handler)

      event_count.should eq(0)
    end
  end
end
