module Layers
  class Menu < Base
    include Traits::ScreenDrawable
    include Traits::Eventable
    include Traits::Updateable

    OVERLAY_COLOR      = CrystalRaylib::Types::Color.new(red: 0, green: 0, blue: 0, alpha: 150)
    PANEL_WIDTH        = 400
    PANEL_HEIGHT       = 350
    PANEL_FILL         = CrystalRaylib::Types::Color.new(red: 30, green: 30, blue: 30, alpha: 240)
    PANEL_BORDER       = CrystalRaylib::Types::Color.new(red: 100, green: 100, blue: 100, alpha: 255)
    PANEL_BORDER_THICK = 2.0_f32

    property? visible : Bool = false
    property elements : Array(UI::Element)
    property settings_elements : Array(UI::Element)
    property current_view : Symbol

    @panel_x : Int32
    @panel_y : Int32
    @mouse_held : Bool = false

    def initialize(@priority : Int32 = 100, @stack : Stack? = nil)
      @elements = [] of UI::Element
      @settings_elements = [] of UI::Element
      @current_view = :main
      @panel_x = (Window::WIDTH - PANEL_WIDTH) // 2
      @panel_y = (Window::HEIGHT - PANEL_HEIGHT) // 2
      subscribe_handler(mouse_pressed_handler, Events::MousePressed)
      subscribe_handler(mouse_released_handler, Events::MouseReleased)
      subscribe_handler(mouse_position_handler, Events::MousePositionChanged)
      subscribe_handler(key_pressed_handler, Events::KeyPressed)
    end

    def visible=(value : Bool)
      old_visible = @visible
      @visible = value
      return if old_visible == value
      if value
        @stack.try(&.block_below_priority(@priority))
      else
        @stack.try(&.unblock_all)
        @current_view = :main
      end
      @mouse_held = false
    end

    def draw : Nil
      return unless visible?
      draw_overlay
      draw_panel
      case @current_view
      when :main
        @elements.each(&.draw)
      when :settings
        @settings_elements.each(&.draw)
      end
    end

    def update(dt : Float32)
      return unless visible?
      active_elements.each do |element|
        if element.is_a?(Traits::TimerUpdatable)
          element.update_timers(dt)
        end
      end
    end

    private def active_elements : Array(UI::Element)
      @current_view == :settings ? @settings_elements : @elements
    end

    private def draw_overlay
      CrystalRaylib::Shapes.draw_rectangle(0, 0, Window::WIDTH, Window::HEIGHT, OVERLAY_COLOR)
    end

    private def draw_panel
      CrystalRaylib::Shapes.draw_rectangle(
        @panel_x, @panel_y, PANEL_WIDTH, PANEL_HEIGHT, PANEL_FILL
      )
      CrystalRaylib::Shapes.draw_rectangle_lines_ex(
        @panel_x, @panel_y, PANEL_WIDTH, PANEL_HEIGHT,
        PANEL_BORDER_THICK, PANEL_BORDER
      )
    end

    private def mouse_pressed_handler : Events::Handlers::CallbackHandler
      @mouse_pressed_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_pressed(event) }
      )
    end

    private def mouse_released_handler : Events::Handlers::CallbackHandler
      @mouse_released_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_released(event) }
      )
    end

    private def on_mouse_pressed(event : Events::Base) : Bool
      return true unless visible? && event.is_a?(Events::MousePressed)
      @mouse_held = true
      handle_click(event.screen_x, event.screen_y)
    end

    private def on_mouse_released(event : Events::Base) : Bool
      return true unless visible?
      @mouse_held = false
      true
    end

    private def on_mouse_position_changed(event : Events::Base) : Bool
      return true unless visible? && event.is_a?(Events::MousePositionChanged)
      handle_hover(event.new_position.screen_x.to_i, event.new_position.screen_y.to_i)
      true
    end

    private def handle_click(mouse_x : Int32, mouse_y : Int32) : Bool
      active_elements.each do |element|
        if element.contains?(mouse_x.to_f32, mouse_y.to_f32)
          element.update(mouse_x, mouse_y, clicked: true)
          return false
        end
      end
      true
    end

    private def handle_hover(mouse_x : Int32, mouse_y : Int32) : Bool
      active_elements.each do |element|
        if @mouse_held
          element.update(mouse_x, mouse_y, clicked: true)
        else
          element.update(mouse_x, mouse_y, clicked: false)
        end
      end
      true
    end

    private def mouse_position_handler : Events::Handlers::CallbackHandler
      @mouse_position_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_position_changed(event) }
      )
    end

    private def key_pressed_handler
      @key_pressed_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_key_pressed(event) }
      )
    end

    private def on_key_pressed(event)
      if event.is_a? Events::KeyPressed
        if event.key == 256
          self.visible = !@visible
        end
      end
    end
  end
end
