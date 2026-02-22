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

  module Input
    @@mock_mouse_position : Types::Vector2 = Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)

    def self.mock_mouse_position=(pos : Types::Vector2)
      @@mock_mouse_position = pos
    end

    def self.mouse_position : Types::Vector2
      @@mock_mouse_position
    end
  end

  module Timing
    @@frame_time : Float32 = 0.016_f32

    def self.frame_time : Float32
      @@frame_time
    end

    def self.frame_time=(value : Float32)
      @@frame_time = value
    end

    def self.target_fps=(fps : Int32)
    end
  end

  module Camera2D
    def self.screen_to_world_2d(vector : Types::Vector2, camera : Types::Camera2D) : Types::Vector2
      Types::Vector2.new(x: vector.x - camera.offset.x, y: vector.y - camera.offset.y)
    end

    def self.with_mode_2d(camera : Types::Camera2D, &block)
      yield
    end
  end

  module Shapes
    def self.draw_rectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Types::Color)
    end

    def self.draw_rectangle_lines_ex(x : Int32, y : Int32, width : Int32, height : Int32, line_thick : Int32, color : Types::Color)
    end
  end

  module Text
    def self.draw_text(text : String, x : Int32, y : Int32, size : Int32, color : Types::Color)
    end
  end

  module Drawing
    def self.draw(&block)
      yield
    end

    def self.clear_background(color : Types::Color)
    end
  end

  module Window
    @@window_should_close : Bool = false

    def self.window_should_close : Bool
      @@window_should_close
    end

    def self.window_should_close=(value : Bool)
      @@window_should_close = value
    end

    def self.with_window(width : Int32, height : Int32, title : Pointer(UInt8), &block)
      yield
    end
  end
end

require "../src/game/game"

Spec.before_each do
  Events::Bus.reset
  Debug::Registry.instance.definitions.clear
  Debug::Registry.instance.values.clear
  Debug::Registry.instance.hidden_items.clear
  Debug::Registry.instance.hidden_categories.clear
  CrystalRaylib::Input.mock_mouse_position = CrystalRaylib::Types::Vector2.new(x: 0.0_f32, y: 0.0_f32)
  CrystalRaylib::Timing.frame_time = 0.016_f32
  CrystalRaylib::Window.window_should_close = false
end
