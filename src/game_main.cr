require "./raylib/raylib"
require "./game/game"

class NonDrawableLayer < Layer
end

class LayerStack
  getter layers : Array(Layer)
  def initialize
    @layers = [] of Layer
  end

  def push(layer : Layer)
    @layers << layer
  end

  def eventable_layers
    @layers.select(&.is_a?(Game::Entities::Eventable))
           .map(&.as(Game::Entities::Eventable))
  end

  def drawable_layers
    @layers.select(&.is_a?(Drawable))
           .map(&.as(Drawable))
  end
end

class Game
  TILE_WIDTH = 64

  property camera : CrystalRaylib::Types::Camera2D
  property layers : LayerStack

  def initialize
    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH / 2 - TILE_WIDTH).to_f32, y: TILE_WIDTH.to_f32)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @layers = LayerStack.new
    @layers.push GameMap.new(width: 16, height: 16)
    @layers.push NonDrawableLayer.new
  end

  def run
    handler = Events::TestHandler.new
    Events::Bus.subscribe(handler, Events::TestEvent)
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
      puts @layers.drawable_layers.size
      @layers.drawable_layers.each &.draw
      @layers.eventable_layers.each &.publish_events
    end
  end
end

game = Game.new
game.run
