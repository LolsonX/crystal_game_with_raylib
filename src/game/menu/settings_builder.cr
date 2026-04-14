module Menu
  class SettingsBuilder < BaseBuilder
    RESOLUTIONS = [
      {1920, 1080},
      {1280, 720},
      {800, 600},
    ]

    @fullscreen_btn : UI::Button?
    @resolution_btn : UI::Button?
    @resolution_index : Int32 = 0

    def build : BaseBuilder
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
        Events::Bus.publish(Events::FullscreenToggled.new(new_value))
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
        Events::Bus.publish(Events::ResolutionChanged.new(new_res[0], new_res[1]))
      }

      back_btn = UI::Button.new(
        location: Core::Geometry::Location.new(x: slider_x, y: (start_y + spacing * 3 + 20).to_f32),
        dimension: Core::Geometry::Dimension.new(width: 150.0_f32, height: 50.0_f32),
        text: "Back"
      )
      back_btn.on_click = -> {
        Events::Bus.publish(Events::MenuViewSwitched.new(:main))
      }

      add(camera_speed_slider)
      add(fullscreen_btn)
      add(resolution_btn)
      add(back_btn)

      subscribe_button_updates
      self
    end

    private def subscribe_button_updates
      Events::Bus.subscribe(
        Events::Handlers::CallbackHandler.new(
          handler: ->(event : Events::Base) {
            if e = event.as?(Events::FullscreenToggled)
              @fullscreen_btn.try(&.text=(e.value? ? "Fullscreen: ON" : "Fullscreen: OFF"))
            end
          }
        ),
        Events::FullscreenToggled,
        priority: -1
      )

      Events::Bus.subscribe(
        Events::Handlers::CallbackHandler.new(
          handler: ->(event : Events::Base) {
            if e = event.as?(Events::ResolutionChanged)
              @resolution_btn.try(&.text=("#{e.width}x#{e.height}"))
            end
          }
        ),
        Events::ResolutionChanged,
        priority: -1
      )
    end
  end
end
