require "../debug"

module Layers
  class Debug < Base
    include Traits::ScreenDrawable
    include Traits::Eventable

    module Limits
      MINIMAL_FRAME_TIME = 0.0000001
    end

    private setter mouse_position : Entities::MousePosition?
    private property tile : Entities::Tile?
    @renderer : DebugRenderer

    def initialize(@priority : Int32 = 10, @visible : Bool = true)
      @renderer = DebugRenderer.new
      register_debug_items
      register_handlers
    end

    def register_debug_items
      DebugRegistry.register("fps", "FPS", "Performance")
      DebugRegistry.register("mouse_screen", "Screen Pos", "Mouse")
      DebugRegistry.register("mouse_world", "World Pos", "Mouse")
      DebugRegistry.register("tile", "Current Tile", "World")
    end

    def draw
      update_fps
      @renderer.render(DebugRegistry.items_by_category)
    end

    def register_handlers
      subscribe_handler(mouse_input_handler, Events::MousePositionChanged)
      subscribe_handler(tile_change_handler, Events::CurrentTileChanged)
    end

    private def update_fps
      fps = (1 // frame_time).to_s
      DebugRegistry.set("fps", fps)
    end

    private def frame_time
      [CrystalRaylib::Timing.frame_time, Limits::MINIMAL_FRAME_TIME].max
    end

    def mouse_input_handler : Events::Handlers::CallbackHandler
      @mouse_input_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_position_changed(event) }
      )
    end

    private def on_mouse_position_changed(event : Events::Base) : Void
      if event.is_a? Events::MousePositionChanged
        @mouse_position = event.new_position
        DebugRegistry.set("mouse_screen", "#{event.new_position.screen_x}, #{event.new_position.screen_y}")
        DebugRegistry.set("mouse_world", "#{event.new_position.world_x}, #{event.new_position.world_y}")
      end
    end

    def tile_change_handler : Events::Handlers::CallbackHandler
      @tile_changed_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_tile_changed(event) }
      )
    end

    private def on_tile_changed(event : Events::Base) : Void
      if event.is_a? Events::CurrentTileChanged
        @tile = event.tile
        if tile = event.tile
          DebugRegistry.set("tile", "#{tile.x}, #{tile.y}")
        else
          DebugRegistry.set("tile", "None")
        end
      end
    end
  end
end
