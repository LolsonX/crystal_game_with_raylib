module Layers
  class Debug < Base
    include Traits::Drawable
    include Traits::Eventable

    module LOCATION
      SCREEN_POSITION = CrystalRaylib::Types::Vector2.new(x: 600, y: 10)
      PADDING_TOP     =  5
      PADDING_LEFT    =  5
      MARGIN_TOP      = 30
    end

    module DIMENSIONS
      WIDTH  = 420
      HEIGHT = 900
    end

    module STYLE
      TEXT_COLOR       = CrystalRaylib::Colors::BLACK
      BACKGROUND_COLOR = CrystalRaylib::Types::Color.new(red: 128, green: 128, blue: 128, alpha: 128)
      FONT_SIZE        = 20
    end

    module LIMITS
      MINIMAL_FRAME_TIME = 0.0000001
    end

    private getter camera : CrystalRaylib::Types::Camera2D
    private property mouse_position : CrystalRaylib::Types::Vector2

    def initialize(@camera : CrystalRaylib::Types::Camera2D, @priority : Int32 = -1, @visible : Bool = true)
      @mouse_position = CrystalRaylib::Types::Vector2.new(x: 0, y: 0)
      register_handlers
    end

    def draw
      draw_background
      draw_fps
      draw_mouse_position
      draw_mouse_world_position
    end

    def register_handlers
      Events::Bus.subscribe(mouse_input_handler, Events::MousePositionChanged)
    end

    def draw_background
      CrystalRaylib::Shapes.draw_rectangle(
        x: LOCATION::SCREEN_POSITION.x.to_i,
        y: LOCATION::SCREEN_POSITION.y.to_i,
        height: DIMENSIONS::HEIGHT,
        width: DIMENSIONS::WIDTH,
        color: STYLE::BACKGROUND_COLOR
      )
    end

    def draw_fps
      CrystalRaylib::Text.draw_text(
        text: "FPS: #{1 // frame_time}",
        x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
        y: LOCATION::SCREEN_POSITION.y.to_i + LOCATION::PADDING_TOP,
        size: STYLE::FONT_SIZE,
        color: STYLE::TEXT_COLOR)
    end

    def draw_mouse_position
      CrystalRaylib::Text.draw_text(
        text: "Mouse position x: #{mouse_position.x} y: #{mouse_position.y}",
        x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
        y: LOCATION::SCREEN_POSITION.y.to_i + LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
        size: STYLE::FONT_SIZE,
        color: STYLE::TEXT_COLOR
      )
    end

    def draw_mouse_world_position
      world_position = CrystalRaylib::Camera2D.screen_to_world_2d(vector: mouse_position, camera: camera)
      CrystalRaylib::Text.draw_text(
        text: "World mouse position x: #{world_position.x} y: #{world_position.y}",
        x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
        y: LOCATION::SCREEN_POSITION.y.to_i + 2 * LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
        size: STYLE::FONT_SIZE,
        color: STYLE::TEXT_COLOR
      )
    end

    def frame_time
      [CrystalRaylib::Timing.frame_time, LIMITS::MINIMAL_FRAME_TIME].max
    end

    def mouse_input_handler : Events::Handlers::MousePositionChanged
      @mouse_input_handler ||= Events::Handlers::MousePositionChanged.new(
        handler: ->(event : Events::Base) { mouse_position_changed_handler(event) }
      )
    end

    def mouse_position_changed_handler(event : Events::Base) : Void
      if event.is_a? Events::MousePositionChanged
        @mouse_position = event.new_position
      end
    end
  end
end
