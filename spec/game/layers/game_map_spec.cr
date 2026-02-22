require "../../spec_helper"

class TestableGameMap < Layers::GameMap
  def tiles_array
    @tiles
  end
end

describe Layers::GameMap do
  context "when initialized with dimensions" do
    it "creates a map of the specified width" do
      map = Layers::GameMap.new(width: 10, height: 8)

      map.width.should eq(10)
    end

    it "creates a map of the specified height" do
      map = Layers::GameMap.new(width: 10, height: 8)

      map.height.should eq(8)
    end

    it "creates tiles in a checkerboard pattern" do
      map = TestableGameMap.new(width: 2, height: 2)

      tile_0_0 = map.tile_at(0, 0)
      tile_1_0 = map.tile_at(1, 0)
      tile_0_1 = map.tile_at(0, 1)
      tile_1_1 = map.tile_at(1, 1)

      tile_0_0.try(&.color).should eq(CrystalRaylib::Colors::BLACK)
      tile_1_0.try(&.color).should eq(CrystalRaylib::Colors::WHITE)
      tile_0_1.try(&.color).should eq(CrystalRaylib::Colors::WHITE)
      tile_1_1.try(&.color).should eq(CrystalRaylib::Colors::BLACK)
    end
  end

  context "when querying a tile at coordinates" do
    it "returns the tile for valid coordinates" do
      map = Layers::GameMap.new(width: 5, height: 5)

      tile = map.tile_at(2, 3)

      tile.should_not be_nil
      tile.try(&.x).should eq(2)
      tile.try(&.y).should eq(3)
    end

    it "returns nil for negative x" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.tile_at(-1, 0).should be_nil
    end

    it "returns nil for negative y" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.tile_at(0, -1).should be_nil
    end

    it "returns nil for x >= width" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.tile_at(5, 0).should be_nil
    end

    it "returns nil for y >= height" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.tile_at(0, 5).should be_nil
    end
  end

  context "when iterating over all tiles" do
    it "yields each tile exactly once" do
      map = Layers::GameMap.new(width: 3, height: 2)
      count = 0

      map.each_tile { |_| count += 1 }

      count.should eq(6)
    end
  end

  context "when tracking the current tile" do
    it "starts with no current tile" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.current_tile.should be_nil
    end
  end

  context "when mouse position changes to a new tile" do
    it "updates the current tile" do
      map = Layers::GameMap.new(width: 5, height: 5)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      world_pos = CrystalRaylib::Types::Vector2.new(x: 64.0_f32, y: 32.0_f32)
      screen_pos = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 100.0_f32)
      mouse_pos = Entities::MousePosition.new(
        screen_position: screen_pos,
        world_position: world_pos,
        camera: camera
      )

      prev_mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        world_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        camera: camera
      )

      event = Events::MousePositionChanged.new(
        previous_position: prev_mouse_pos,
        new_position: mouse_pos
      )

      Events::Bus.instance.publish(event)

      map.current_tile.should_not be_nil
    end

    it "publishes CurrentTileChanged event when tile changes" do
      map = Layers::GameMap.new(width: 5, height: 5)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      received_tile = nil
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) {
          if event.is_a?(Events::CurrentTileChanged)
            received_tile = event.tile
          end
        }
      )
      Events::Bus.instance.subscribe(handler, Events::CurrentTileChanged, priority: 0)

      world_pos = CrystalRaylib::Types::Vector2.new(x: 64.0_f32, y: 32.0_f32)
      mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        world_position: world_pos,
        camera: camera
      )
      prev_mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        world_position: CrystalRaylib::Types::Vector2.new(x: -1000.0_f32, y: -1000.0_f32),
        camera: camera
      )

      event = Events::MousePositionChanged.new(
        previous_position: prev_mouse_pos,
        new_position: mouse_pos
      )

      Events::Bus.instance.publish(event)
      map.process_events
      Events::Bus.instance.unsubscribe(handler)

      received_tile.should_not be_nil
    end
  end

  context "when mouse position stays on the same tile" do
    it "does not publish CurrentTileChanged event" do
      map = Layers::GameMap.new(width: 5, height: 5)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      world_pos = CrystalRaylib::Types::Vector2.new(x: 64.0_f32, y: 32.0_f32)
      mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        world_position: world_pos,
        camera: camera
      )

      event_count = 0
      handler = Events::Handlers::CallbackHandler.new(
        handler: ->(_event : Events::Base) { event_count += 1 }
      )
      Events::Bus.instance.subscribe(handler, Events::CurrentTileChanged, priority: 0)

      prev_mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        world_position: CrystalRaylib::Types::Vector2.new(x: -1000.0_f32, y: -1000.0_f32),
        camera: camera
      )

      event1 = Events::MousePositionChanged.new(
        previous_position: prev_mouse_pos,
        new_position: mouse_pos
      )
      Events::Bus.instance.publish(event1)
      map.process_events

      event2 = Events::MousePositionChanged.new(
        previous_position: mouse_pos,
        new_position: mouse_pos
      )
      Events::Bus.instance.publish(event2)
      map.process_events

      Events::Bus.instance.unsubscribe(handler)

      event_count.should eq(1)
    end
  end
end
