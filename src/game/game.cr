require "../raylib/crystal_raylib"
require "./macros/macros"
require "./settings/settings"
require "./traits/traits"
require "./events/events"
require "./core/core"
require "./window"
require "./debug"
require "./entities/entity"
require "./ui/ui"
require "./layers/layers"

class Game
  property camera : CrystalRaylib::Types::Camera2D
  property layer_stack : Layers::Stack
  TILES_PER_ROW    = 64
  TILES_PER_COLUMN = 64

  @fullscreen_btn : UI::Button?
  @resolution_btn : UI::Button?
  @resolution_index : Int32 = 0

  RESOLUTIONS = [
    {1920, 1080},
    {1280, 720},
    {800, 600},
  ]

  def initialize
    Settings::Registry.instance.load

    camera_offset = CrystalRaylib::Types::Vector2.new(x: (Window::WIDTH - Entities::Tile::WIDTH) / 2_f32, y: 0)
    camera_target = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    @camera = CrystalRaylib::Types::Camera2D.new(offset: camera_offset, target: camera_target)
    @layer_stack = Layers::Stack.new
    @window_close_requested
    populate_layer_stack
    Events::Bus.subscribe(Events::Handlers::KeyPressed.new, Events::KeyPressed, priority: 0)
  end

  def populate_layer_stack
    @layer_stack.push Layers::GameMap.new(width: TILES_PER_COLUMN, height: TILES_PER_ROW)
    @layer_stack.push Layers::Debug.new
    @layer_stack.push Layers::Input.new(camera: camera)
    @layer_stack.push Layers::Camera.new(camera: camera, priority: 1)

    @layer_stack.push build_menu
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

  private def build_menu
    Layers::Menu.new(priority: 100, stack: @layer_stack).tap do |menu|
      build_main_menu(menu)
      build_settings_menu(menu)
    end
  end

  private def build_main_menu(menu : Layers::Menu)
    panel_x = (Window::WIDTH - Layers::Menu::PANEL_WIDTH) // 2
    btn_width = 150.0_f32
    btn_height = 50.0_f32
    btn_x = (panel_x + (Layers::Menu::PANEL_WIDTH - btn_width) / 2).to_f32
    start_y = (Window::HEIGHT - Layers::Menu::PANEL_HEIGHT) // 2 + 80
    spacing = 60

    resume_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: btn_x, y: start_y.to_f32),
      dimension: Core::Geometry::Dimension.new(width: btn_width, height: btn_height),
      text: "Resume"
    )
    resume_btn.on_click = -> { menu.visible = false }

    options_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: btn_x, y: (start_y + spacing).to_f32),
      dimension: Core::Geometry::Dimension.new(width: btn_width, height: btn_height),
      text: "Options"
    )
    options_btn.on_click = -> { menu.current_view = :settings }

    exit_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: btn_x, y: (start_y + spacing * 2).to_f32),
      dimension: Core::Geometry::Dimension.new(width: btn_width, height: btn_height),
      text: "Exit"
    )
    exit_btn.on_click = -> { @window_close_requested = true }

    menu.elements << resume_btn
    menu.elements << options_btn
    menu.elements << exit_btn
  end

  private def build_settings_menu(menu : Layers::Menu)
    panel_x = (Window::WIDTH - Layers::Menu::PANEL_WIDTH) // 2
    slider_x = (panel_x + 40).to_f32
    start_y = (Window::HEIGHT - Layers::Menu::PANEL_HEIGHT) // 2 + 60
    spacing = 70

    camera_speed_slider = UI::Slider.new(
      label: "Camera Speed",
      min: 500.0_f32,
      max: 3000.0_f32,
      value: Settings::Registry.instance.get_float("camera_speed", 1500.0_f32),
      location: Core::Geometry::Location.new(x: slider_x, y: start_y.to_f32),
      track_width: 200.0_f32,
    )
    camera_speed_slider.on_change = ->(value : Float32) {
      Settings::Registry.instance.set("camera_speed", value.to_f64)
      Settings::Registry.instance.save
    }

    fullscreen_value = Settings::Registry.instance.get_bool("fullscreen", false)
    fullscreen_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: slider_x, y: (start_y + spacing).to_f32),
      dimension: Core::Geometry::Dimension.new(width: 200.0_f32, height: 40.0_f32),
      text: fullscreen_value ? "Fullscreen: ON" : "Fullscreen: OFF",
    )
    @fullscreen_btn = fullscreen_btn
    fullscreen_btn.on_click = -> {
      current = Settings::Registry.instance.get_bool("fullscreen", false)
      new_value = !current
      Settings::Registry.instance.set("fullscreen", new_value)
      Settings::Registry.instance.save
      @fullscreen_btn.try(&.text=(new_value ? "Fullscreen: ON" : "Fullscreen: OFF"))
      CrystalRaylib::Window.toggle_fullscreen
    }

    saved_w = Settings::Registry.instance.get_int("resolution_width", 1920)
    saved_h = Settings::Registry.instance.get_int("resolution_height", 1080)
    @resolution_index = RESOLUTIONS.index(RESOLUTIONS.find { |res| res[0] == saved_w && res[1] == saved_h }) || 0
    res = RESOLUTIONS[@resolution_index]
    resolution_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: slider_x, y: (start_y + spacing * 2).to_f32),
      dimension: Core::Geometry::Dimension.new(width: 200.0_f32, height: 40.0_f32),
      text: "#{res[0]}x#{res[1]}",
    )
    @resolution_btn = resolution_btn
    resolution_btn.on_click = -> {
      @resolution_index = (@resolution_index + 1) % RESOLUTIONS.size
      new_res = RESOLUTIONS[@resolution_index]
      Settings::Registry.instance.set("resolution_width", new_res[0])
      Settings::Registry.instance.set("resolution_height", new_res[1])
      Settings::Registry.instance.save
      @resolution_btn.try(&.text=("#{new_res[0]}x#{new_res[1]}"))
      CrystalRaylib::Window.set_window_size(new_res[0], new_res[1])
    }

    back_btn = UI::Button.new(
      location: Core::Geometry::Location.new(x: slider_x, y: (start_y + spacing * 3 + 20).to_f32),
      dimension: Core::Geometry::Dimension.new(width: 150.0_f32, height: 50.0_f32),
      text: "Back"
    )
    back_btn.on_click = -> { menu.current_view = :main }

    menu.settings_elements << camera_speed_slider
    menu.settings_elements << fullscreen_btn
    menu.settings_elements << resolution_btn
    menu.settings_elements << back_btn
  end
end
