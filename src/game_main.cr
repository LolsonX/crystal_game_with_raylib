require "./raylib/raylib"
require "./game/window"
require "./game/entities/tile"

class Game
  TILE_WIDTH = 64
  property camera : CrystalRaylib::Types::Camera2D
  property tiles : Array(Tile?)

  def initialize
    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH / 2 - TILE_WIDTH).to_f32, y: TILE_WIDTH.to_f32)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @tiles = Array(Tile?).new(16*16) { nil }
    0.upto(15) do |x|
      0.upto(15) do |y|
        if x % 2 == 1 && y % 2 == 0 || x % 2 == 0 && y % 2 == 1
          @tiles[x * 16 + y] = Tile.new(x: x, y: y, color: CrystalRaylib::Colors::RED)
        else
          @tiles[x * 16 + y] = Tile.new(x: x, y: y, color: CrystalRaylib::Colors::GREEN)
        end
      end
    end
  end

  def run
    CrystalRaylib::Window.with_window(Window::WIDTH, Window::HEIGHT, "Hello from crystal".to_unsafe) do
      CrystalRaylib::Timing.target_fps = 60
      until CrystalRaylib::Window.window_should_close
        CrystalRaylib::Drawing.draw { draw }
      end
    end
  end

  private def draw
    CrystalRaylib::Drawing.clear_background(CrystalRaylib::Types::Color.new(red: 31, green: 31, blue: 31, alpha: 255))
    CrystalRaylib::Camera2D.with_mode_2d(camera) do
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
