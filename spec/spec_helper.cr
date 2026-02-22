require "spec"

module CrystalRaylib
  module Types
    struct Vector2
      getter x : Float32
      getter y : Float32

      def initialize(@x : Float32, @y : Float32)
      end

      def ==(other : Vector2) : Bool
        x == other.x && y == other.y
      end
    end

    struct Color
      getter red : UInt8
      getter green : UInt8
      getter blue : UInt8
      getter alpha : UInt8

      def initialize(@red : UInt8, @green : UInt8, @blue : UInt8, @alpha : UInt8)
      end

      def ==(other : Color) : Bool
        red == other.red && green == other.green && blue == other.blue && alpha == other.alpha
      end
    end

    struct Camera2D
      getter offset : Vector2
      getter target : Vector2
      getter rotation : Float32
      getter zoom : Float32

      def initialize(@offset : Vector2, @target : Vector2, @rotation : Float32 = 0.0_f32, @zoom : Float32 = 1.0_f32)
      end
    end
  end

  module Colors
    WHITE      = Types::Color.new(red: 255, green: 255, blue: 255, alpha: 255)
    BLACK      = Types::Color.new(red: 0, green: 0, blue: 0, alpha: 255)
    RED        = Types::Color.new(red: 255, green: 0, blue: 0, alpha: 255)
    LIGHT_GRAY = Types::Color.new(red: 200, green: 200, blue: 200, alpha: 255)
  end
end

require "../src/game/events/base"
require "../src/game/events/bus"
require "../src/game/events/mouse_position_changed"
require "../src/game/events/current_tile_changed"
require "../src/game/events/key_pressed"
require "../src/game/events/handlers/base"
require "../src/game/events/handlers/key_pressed"
require "../src/game/traits/eventable"
require "../src/game/traits/world_drawable"
require "../src/game/traits/screen_drawable"
require "../src/game/layers/base"
require "../src/game/layers/stack"
require "../src/game/entities/tile"
require "../src/game/entities/mouse_position"
require "../src/game/debug/registry"

Spec.before_each do
  Events::Bus.reset
end
