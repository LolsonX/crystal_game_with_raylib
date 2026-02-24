require "./traits/traits"
require "./events/events"
require "./window"
require "./entities/entity"
require "./layers/layers"

class Game
  property camera : CrystalRaylib::Types::Camera2D
  property layer_stack : Layers::Stack
  TILES_PER_ROW = 64
  TILES_PER_COLUMN = 64

  def initialize
    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH - Entities::Tile::WIDTH) / 2_f32, y: 0)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @layer_stack = Layers::Stack.new
    populate_layer_stack
    Events::Bus.subscribe(Events::Handlers::KeyPressed.new, Events::KeyPressed, priority: 0)
  end

  def populate_layer_stack
    @layer_stack.push Layers::GameMap.new(width: TILES_PER_COLUMN, height: TILES_PER_ROW)
    @layer_stack.push Layers::Debug.new
    @layer_stack.push Layers::Input.new(camera: camera)
    @layer_stack.push Layers::Camera.new(camera: camera, priority: 1)
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
      @layer_stack.each_with_trait(Traits::WorldDrawable, &.draw)
      @layer_stack.each_with_trait(Traits::Eventable, &.emit)
      @layer_stack.each_with_trait(Traits::Eventable, &.process_events)
      @layer_stack.each_with_trait(Traits::Updateable, &.update(CrystalRaylib::Timing.frame_time))
    end

    @layer_stack.each_with_trait(Traits::ScreenDrawable, &.draw)
  end
end
