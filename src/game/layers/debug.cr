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

    private setter mouse_position : Entities::MousePosition?
    private property tile : Entities::Tile?

    def initialize(@priority : Int32 = -1, @visible : Bool = true)
      register_handlers
    end

    def draw
      draw_background
      draw_fps
      draw_mouse_position
      draw_mouse_world_position
      draw_current_tile_info
    end

    def register_handlers
      Events::Bus.subscribe(mouse_input_handler, Events::MousePositionChanged)
      Events::Bus.subscribe(tile_change_handler, Events::CurrentTileChanged)
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
      if mouse_position = @mouse_position
        CrystalRaylib::Text.draw_text(
          text: "Mouse position x: #{mouse_position.screen_x} y: #{mouse_position.screen_y}",
          x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
          y: LOCATION::SCREEN_POSITION.y.to_i + LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
          size: STYLE::FONT_SIZE,
          color: STYLE::TEXT_COLOR
        )
      end
    end

    def draw_mouse_world_position
      if mouse_position = @mouse_position
        CrystalRaylib::Text.draw_text(
          text: "World mouse position x: #{mouse_position.world_x} y: #{mouse_position.world_y}",
          x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
          y: LOCATION::SCREEN_POSITION.y.to_i + 2 * LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
          size: STYLE::FONT_SIZE,
          color: STYLE::TEXT_COLOR
        )
      end
    end

    def draw_current_tile_info
      if current_tile = tile
        CrystalRaylib::Text.draw_text(
          text: "Current Tile: x: #{current_tile.x}, y: #{current_tile.y}",
          x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
          y: LOCATION::SCREEN_POSITION.y.to_i + 3 * LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
          size: STYLE::FONT_SIZE,
          color: STYLE::TEXT_COLOR
        )
      else
        CrystalRaylib::Text.draw_text(
          text: "Current Tile: x: None, y: None",
          x: LOCATION::SCREEN_POSITION.x.to_i + LOCATION::PADDING_LEFT,
          y: LOCATION::SCREEN_POSITION.y.to_i + 3 * LOCATION::MARGIN_TOP + LOCATION::PADDING_TOP,
          size: STYLE::FONT_SIZE,
          color: STYLE::TEXT_COLOR
        )
      end
    end

    def frame_time
      [CrystalRaylib::Timing.frame_time, LIMITS::MINIMAL_FRAME_TIME].max
    end

    def mouse_input_handler : Events::Handlers::CallbackHandler
      @mouse_input_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { mouse_position_changed_handler(event) }
      )
    end

    def mouse_position_changed_handler(event : Events::Base) : Void
      if event.is_a? Events::MousePositionChanged
        @mouse_position = event.new_position
      end
    end

    def tile_change_handler : Events::Handlers::CallbackHandler
      @tile_changed_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_tile_changed(event) }
      )
    end

    def on_tile_changed(event)
      if event.is_a? Events::CurrentTileChanged
        @tile = event.tile
      end
    end
  end
end
