require "../../spec_helper"

module CrystalRaylib
  module Camera2D
    def self.screen_to_world_2d(vector : Types::Vector2, camera : Types::Camera2D) : Types::Vector2
      Types::Vector2.new(x: vector.x - camera.offset.x, y: vector.y - camera.offset.y)
    end
  end
end

require "../../../src/game/layers/game_map"

class TestableGameMap < Layers::GameMap
  def tiles_array
    @tiles
  end
end

describe Layers::GameMap do
  describe "#initialize" do
    it "creates map with specified dimensions" do
      map = Layers::GameMap.new(width: 10, height: 8)

      map.width.should eq(10)
      map.height.should eq(8)
    end

    it "creates checkerboard pattern" do
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

  describe "#tile_at" do
    it "returns tile at valid coordinates" do
      map = Layers::GameMap.new(width: 5, height: 5)

      tile = map.tile_at(2, 3)

      tile.should_not be_nil
      tile.try(&.x).should eq(2)
      tile.try(&.y).should eq(3)
    end

    it "returns nil for x < 0" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.tile_at(-1, 0).should be_nil
    end

    it "returns nil for y < 0" do
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

  describe "#each_tile" do
    it "yields all tiles" do
      map = Layers::GameMap.new(width: 3, height: 2)
      count = 0

      map.each_tile { |_| count += 1 }

      count.should eq(6)
    end
  end

  describe "current_tile tracking" do
    it "starts with no current tile" do
      map = Layers::GameMap.new(width: 5, height: 5)

      map.current_tile.should be_nil
    end
  end
end
