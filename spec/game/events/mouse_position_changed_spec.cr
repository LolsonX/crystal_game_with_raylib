require "../../spec_helper"

describe Events::MousePositionChanged do
  context "when initialized with previous and new positions" do
    it "stores both positions" do
      screen = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      previous_pos = Entities::MousePosition.new(
        screen_position: screen,
        world_position: CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32),
        camera: camera
      )
      new_pos = Entities::MousePosition.new(
        screen_position: screen,
        world_position: CrystalRaylib::Types::Vector2.new(x: 150.0_f32, y: 250.0_f32),
        camera: camera
      )

      event = Events::MousePositionChanged.new(previous_position: previous_pos, new_position: new_pos)

      event.previous_position.should eq(previous_pos)
      event.new_position.should eq(new_pos)
    end
  end
end
