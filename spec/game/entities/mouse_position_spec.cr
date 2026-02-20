require "../../spec_helper"

describe Entities::MousePosition do
  describe "#initialize" do
    it "stores screen and world positions" do
      screen = CrystalRaylib::Types::Vector2.new(x: 100.0_f32, y: 200.0_f32)
      world = CrystalRaylib::Types::Vector2.new(x: 50.0_f32, y: 75.0_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      mouse_pos = Entities::MousePosition.new(
        screen_position: screen,
        world_position: world,
        camera: camera
      )

      mouse_pos.screen_position.should eq(screen)
      mouse_pos.world_position.should eq(world)
      mouse_pos.camera.should eq(camera)
    end
  end

  describe "#roughly_equals?" do
    it "returns true for positions within EPSILON" do
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

    it "returns false for positions outside EPSILON" do
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

  describe "#world_x and #world_y" do
    it "returns world position components" do
      screen = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      world = CrystalRaylib::Types::Vector2.new(x: 123.5_f32, y: 456.7_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      mouse_pos = Entities::MousePosition.new(screen_position: screen, world_position: world, camera: camera)

      mouse_pos.world_x.should eq(123.5_f32)
      mouse_pos.world_y.should eq(456.7_f32)
    end
  end

  describe "#screen_x and #screen_y" do
    it "returns screen position components" do
      screen = CrystalRaylib::Types::Vector2.new(x: 800.0_f32, y: 600.0_f32)
      world = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      camera = CrystalRaylib::Types::Camera2D.new(
        offset: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32),
        target: CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
      )

      mouse_pos = Entities::MousePosition.new(screen_position: screen, world_position: world, camera: camera)

      mouse_pos.screen_x.should eq(800.0_f32)
      mouse_pos.screen_y.should eq(600.0_f32)
    end
  end
end
