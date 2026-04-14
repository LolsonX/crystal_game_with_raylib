require "../raylib/crystal_raylib"
require "./macros"
require "./settings"
require "./traits"
require "./events"
require "./core"
require "./window"
require "./debug"
require "./entities"
require "./ui"
require "./menu"
require "./layers"

class Game
  property camera : CrystalRaylib::Types::Camera2D
  property layer_stack : Layers::Stack
  property? window_close_requested : Bool = false
  TILES_PER_ROW    = 64
  TILES_PER_COLUMN = 64

  def initialize
    Settings::Registry.instance.load

    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH - Entities::Tile::WIDTH) / 2_f32, y: 0)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @layer_stack = Layers::Stack.new
    populate_layer_stack

    Events::Bus.subscribe(Events::Handlers::KeyPressed.new, Events::KeyPressed, priority: 0)
    Events::Bus.subscribe(Events::Handlers::WindowCloseRequested.new(self), Events::WindowCloseRequested, priority: 0)
    Events::Bus.subscribe(Events::Handlers::FullscreenToggled.new, Events::FullscreenToggled, priority: 0)
    Events::Bus.subscribe(Events::Handlers::ResolutionChanged.new, Events::ResolutionChanged, priority: 0)
  end

  def populate_layer_stack
    @layer_stack.push Layers::GameMap.new(width: TILES_PER_COLUMN, height: TILES_PER_ROW)
    @layer_stack.push Layers::Debug.new
    @layer_stack.push Layers::Input.new(camera: camera)
    @layer_stack.push Layers::Camera.new(camera: camera, priority: 1)

    Layers::Menu.new(priority: 100, stack: @layer_stack)
                .tap { |menu| menu.elements |= Menu::MainBuilder.build.elements }
                .tap { |menu| menu.settings_elements |= Menu::SettingsBuilder.build.elements }
                .tap { |menu| @layer_stack.push menu }
  end

  def run
    CrystalRaylib::Window.with_window(Window::WIDTH, Window::HEIGHT, "Hello from crystal".to_unsafe) do
      CrystalRaylib::Timing.target_fps = 60
      CrystalRaylib::Input.exit_key = -1

      until CrystalRaylib::Window.window_should_close || @window_close_requested
        CrystalRaylib::Drawing.draw { draw }
      end
    end
    Settings::Registry.instance.save
  end

  private def draw
    CrystalRaylib::Drawing.clear_background(CrystalRaylib::Types::Color.new(red: 31, green: 31, blue: 31, alpha: 255))

    CrystalRaylib::Camera2D.with_mode_2d(camera) do
      @layer_stack.each_with_trait(Traits::WorldDrawable, &.draw)
      @layer_stack.each_with_trait(Traits::Eventable, &.emit)
      @layer_stack.each_with_trait(Traits::Eventable, &.process_events)
      @layer_stack.each_with_trait_unblocked(Traits::Updateable, &.update(CrystalRaylib::Timing.frame_time))
    end

    @layer_stack.each_with_trait(Traits::ScreenDrawable, &.draw)
  end
end
