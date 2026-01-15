require "./raylib/raylib"
require "./game/game"

class Game
  TILE_WIDTH = 64

  property camera : CrystalRaylib::Types::Camera2D
  property map : GameMap

  def initialize
    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH / 2 - TILE_WIDTH).to_f32, y: TILE_WIDTH.to_f32)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @map = GameMap.new(width: 16, height: 16)
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
      @map.draw
    end
  end
end

game = Game.new
game.run
