require "./raylib/raylib"
require "./game/window"
require "./game/entities/tile"

class Game
  TILE_WIDTH = 64
  property camera : CrystalRaylib::Camera2D
  property tiles : Array(Tile?)
  COLORS = {
    red:   CrystalRaylib::Color.new(r: 200, g: 31, b: 31, a: 255),
    green: CrystalRaylib::Color.new(r: 31, g: 200, b: 31, a: 255),
  }

  def initialize
    camera_offset = CrystalRaylib::Vector2.new(x: Window::WIDTH / 2 - TILE_WIDTH, y: TILE_WIDTH)
    camera_target = CrystalRaylib::Vector2.new(x: 0.0, y: 0.0)
    @camera = CrystalRaylib::Camera2D.new(offset: camera_offset, target: camera_target, rotation: 0, zoom: 1.0_f32)
    @tiles = Array(Tile?).new(16*16) { nil }
    0..15.times do |x|
      0..15.times do |y|
        if x % 2 == 1 && y % 2 == 0 || x % 2 == 0 && y % 2 == 1
          @tiles[x * 16 + y] = Tile.new(x: x, y: y, color: COLORS[:red])
        else
          @tiles[x * 16 + y] = Tile.new(x: x, y: y, color: COLORS[:green])
        end
      end
    end
  end

  def run
    CrystalRaylib.with_window(Window::WIDTH, Window::HEIGHT, "Hello from crystal".to_unsafe) do
      CrystalRaylib.target_fps = 60
      until CrystalRaylib.window_should_close
        CrystalRaylib.draw { draw }
      end
    end
  end

  private def draw
    CrystalRaylib.clear_background(CrystalRaylib::Color.new(r: 31, g: 31, b: 31, a: 255))
    CrystalRaylib.with_mode_2d(camera) do
      @tiles.each do |tile|
        if world_tile = tile
          world_tile.draw
        end
      end
    end
  end
end

game = Game.new
game.run
