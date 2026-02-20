module Layers
  class GameMap < Base
    include Traits::Drawable
    include Traits::Eventable
    getter width : Int32
    getter height : Int32
    getter tile_width : Int32
    getter tile_height : Int32
    getter current_tile : Entities::Tile?

    def initialize(@width : Int32, @height : Int32, @tile_width : Int32 = 128, @tile_height : Int32 = 64, @priority : Int32 = 0)
      super(priority: @priority)
      @tiles = Array(Entities::Tile?).new(width * height) { nil }
      create_checkerboard_pattern
      register_handlers
    end

    def register_handlers
      subscribe_handler(mouse_input_handler, Events::MousePositionChanged)
    end

    def mouse_input_handler : Events::Handlers::CallbackHandler
      @mouse_input_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { mouse_position_changed_handler(event) }
      )
    end

    def mouse_position_changed_handler(event : Events::Base) : Void
      if event.is_a? Events::MousePositionChanged
        new_tile = calculate_current_tile(event.new_position.world_position)
        if new_tile != @current_tile
          @current_tile = new_tile
          publish_event(Events::CurrentTileChanged.new(tile: new_tile))
        end
      end
    end

    def tile_at(x : Int32, y : Int32) : Entities::Tile?
      return nil if x < 0 || x >= @width || y < 0 || y >= @height
      @tiles[y * @width + x]?
    end

    def each_tile(&)
      @height.times do |y|
        @width.times do |x|
          yield tile_at(x, y)
        end
      end
    end

    def draw
      each_tile do |tile|
        if current_tile = tile
          current_tile.draw(with_outline: @current_tile == current_tile)
        end
      end
    end

    def emit; end

    private def calculate_current_tile(position : CrystalRaylib::Types::Vector2)
      x = position.x / Entities::Tile::WIDTH * 2
      y = position.y / Entities::Tile::HEIGHT * 2
      tile_x = ((x + y - 1) // 2).to_i32
      tile_y = ((y - x + 1) // 2).to_i32
      tile_at(tile_x, tile_y)
    end

    private def create_checkerboard_pattern
      @height.times do |y|
        @width.times do |x|
          color = if (x % 2 == 1 && y % 2 == 0) || (x % 2 == 0 && y % 2 == 1)
                    CrystalRaylib::Colors::WHITE
                  else
                    CrystalRaylib::Colors::BLACK
                  end
          @tiles[y * @width + x] = Entities::Tile.new(x: x, y: y, color: color)
        end
      end
    end
  end
end
