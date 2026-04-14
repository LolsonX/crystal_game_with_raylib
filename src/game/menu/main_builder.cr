module Menu
  class MainBuilder < BaseBuilder
    def build : BaseBuilder
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
      resume_btn.on_click = -> {
        Events::Bus.publish(Events::MenuViewSwitched.new(:hidden))
      }

      options_btn = UI::Button.new(
        location: Core::Geometry::Location.new(x: btn_x, y: (start_y + spacing).to_f32),
        dimension: Core::Geometry::Dimension.new(width: btn_width, height: btn_height),
        text: "Options"
      )
      options_btn.on_click = -> {
        Events::Bus.publish(Events::MenuViewSwitched.new(:settings))
      }

      exit_btn = UI::Button.new(
        location: Core::Geometry::Location.new(x: btn_x, y: (start_y + spacing * 2).to_f32),
        dimension: Core::Geometry::Dimension.new(width: btn_width, height: btn_height),
        text: "Exit"
      )
      exit_btn.on_click = -> {
        Events::Bus.publish(Events::WindowCloseRequested.new)
      }

      add(resume_btn)
      add(options_btn)
      add(exit_btn)
      self
    end
  end
end
