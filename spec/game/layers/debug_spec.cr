require "../../spec_helper"

describe Layers::Debug do
  context "when initialized" do
    it "registers debug items in the registry" do
      Layers::Debug.new

      Debug::Registry.instance.definitions.has_key?("fps").should be_true
      Debug::Registry.instance.definitions.has_key?("mouse_screen").should be_true
      Debug::Registry.instance.definitions.has_key?("mouse_world").should be_true
      Debug::Registry.instance.definitions.has_key?("tile").should be_true
    end

    it "includes ScreenDrawable for screen-space rendering" do
      debug = Layers::Debug.new

      debug.is_a?(Traits::ScreenDrawable).should be_true
    end
  end

  context "when MousePositionChanged event is received" do
    it "updates the registry with screen and world coordinates" do
      Layers::Debug.new

      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      mouse_pos = Entities::MousePosition.new(
        screen_position: CrystalRaylib::Types::Vector2.new(x: 800.0_f32, y: 600.0_f32),
        world_position: CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32),
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

      Debug::Registry.get("mouse_screen").should eq("800.0, 600.0")
      Debug::Registry.get("mouse_world").should eq("100.0, 200.0")
    end
  end

  context "when CurrentTileChanged event is received with a tile" do
    it "updates the registry with tile coordinates" do
      Layers::Debug.new

      tile = Entities::Tile.new(x: 5, y: 10)
      event = Events::CurrentTileChanged.new(tile: tile)

      Events::Bus.instance.publish(event)

      Debug::Registry.get("tile").should eq("5, 10")
    end
  end

  context "when CurrentTileChanged event is received with nil" do
    it "sets the registry value to 'None'" do
      Layers::Debug.new

      event = Events::CurrentTileChanged.new(tile: nil)

      Events::Bus.instance.publish(event)

      Debug::Registry.get("tile").should eq("None")
    end
  end
end
