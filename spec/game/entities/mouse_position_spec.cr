require "../../spec_helper"

describe Entities::MousePosition do
  context "when comparing positions with roughly_equals?" do
    it "returns true for positions within EPSILON tolerance" do
      screen = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      world1 = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32)
      world2 = CrystalRaylib::Types::Vector2.new(x: 100.0005_f32, y: 200.0_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      pos1 = Entities::MousePosition.new(screen_position: screen, world_position: world1, camera: camera)
      pos2 = Entities::MousePosition.new(screen_position: screen, world_position: world2, camera: camera)

      pos1.roughly_equals?(pos2).should be_true
    end

    it "returns false for positions outside EPSILON tolerance" do
      screen = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      world1 = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32)
      world2 = CrystalRaylib::Types::Vector2.new(x: 101.0_f32, y: 200.0_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      pos1 = Entities::MousePosition.new(screen_position: screen, world_position: world1, camera: camera)
      pos2 = Entities::MousePosition.new(screen_position: screen, world_position: world2, camera: camera)

      pos1.roughly_equals?(pos2).should be_false
    end
  end
end
