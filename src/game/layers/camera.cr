module Layers
  class Camera < Base
    include Traits::Eventable
    include Traits::Updateable

    CAMERA_MOVEMENT_BORDER = 50
    MAX_X_OFFSET = Entities::Tile::WIDTH * Game::TILES_PER_COLUMN / 2
    MAX_Y_OFFSET = Entities::Tile::HEIGHT * Game::TILES_PER_ROW
    CAMERA_SPEED = 1500

    private property x_direction : Int32
    private property y_direction : Int32
    private getter camera : CrystalRaylib::Types::Camera2D

    def initialize(@camera : CrystalRaylib::Types::Camera2D, @priority : Int32)
      @x_direction = 0
      @y_direction = 0
      register_event_handlers
    end

    def register_event_handlers
      subscribe_handler(mouse_position_changed_handler, Events::MousePositionChanged)
    end

    def mouse_position_changed_handler
      Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_position_changed(event) }
      )
    end

    def update(dt : Float32)
      if x_direction != 0 || y_direction != 0
        offset_x = (offset.x + x_direction * CAMERA_SPEED * dt).clamp(-MAX_X_OFFSET, MAX_X_OFFSET)
        offset_y = (offset.y + y_direction * CAMERA_SPEED * dt).clamp(-MAX_Y_OFFSET, 0)
        camera.update(x: offset_x, y: offset_y)
      end
    end

    def on_mouse_position_changed(event)
      if event.is_a?(Events::MousePositionChanged)
        screen_position = event.new_position.screen_position
        move_x(screen_position)
        move_y(screen_position)
      end
    end

    private def move_x(screen_position : CrystalRaylib::Types::Vector2)
      if screen_position.x > 1920 - CAMERA_MOVEMENT_BORDER
        @x_direction = -1
      elsif screen_position.x < CAMERA_MOVEMENT_BORDER
        @x_direction = 1
      else
        @x_direction = 0
      end
    end

    private def move_y(screen_position : CrystalRaylib::Types::Vector2)
      if screen_position.y > 1080 - CAMERA_MOVEMENT_BORDER
        @y_direction = -1
      elsif screen_position.y < CAMERA_MOVEMENT_BORDER
        @y_direction = 1
      else
        @y_direction = 0
      end
    end

    private def offset
      camera.offset
    end
  end
end
