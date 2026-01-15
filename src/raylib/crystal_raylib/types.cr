module CrystalRaylib
  module Types
    struct Color
      def initialize(@red : UInt8, @green : UInt8, @blue : UInt8, @alpha : UInt8 = 255)
      end
    end

    struct Vector2
      def initialize(@x : Float32, @y : Float32)
      end
    end

    struct Camera2D
      def initialize(@offset : Vector2, @target : Vector2, @rotation : Float32 = 0.0_f32, @zoom : Float32 = 1.0_f32)
      end
    end
  end

  module Colors
    LIGHT_GRAY  = Types::Color.new(red: 200, green: 200, blue: 200, alpha: 255)
    GRAY        = Types::Color.new(red: 130, green: 130, blue: 130, alpha: 255)
    DARK_GRAY   = Types::Color.new(red: 80, green: 80, blue: 80, alpha: 255)
    YELLOW      = Types::Color.new(red: 253, green: 249, blue: 0, alpha: 255)
    GOLD        = Types::Color.new(red: 255, green: 203, blue: 0, alpha: 255)
    ORANGE      = Types::Color.new(red: 255, green: 161, blue: 0, alpha: 255)
    RED         = Types::Color.new(red: 230, green: 41, blue: 55, alpha: 255)
    MAROON      = Types::Color.new(red: 190, green: 33, blue: 55, alpha: 255)
    GREEN       = Types::Color.new(red: 0, green: 228, blue: 48, alpha: 255)
    LIME        = Types::Color.new(red: 162, green: 235, blue: 52, alpha: 255)
    DARK_GREEN  = Types::Color.new(red: 0, green: 158, blue: 47, alpha: 255)
    SKY_BLUE    = Types::Color.new(red: 102, green: 191, blue: 255, alpha: 255)
    BLUE        = Types::Color.new(red: 0, green: 121, blue: 241, alpha: 255)
    DARK_BLUE   = Types::Color.new(red: 0, green: 82, blue: 172, alpha: 255)
    PURPLE      = Types::Color.new(red: 200, green: 55, blue: 148, alpha: 255)
    VIOLET      = Types::Color.new(red: 135, green: 0, blue: 189, alpha: 255)
    DARK_PURPLE = Types::Color.new(red: 112, green: 31, blue: 126, alpha: 255)
    BLACK       = Types::Color.new(red: 0, green: 0, blue: 0, alpha: 255)
    WHITE       = Types::Color.new(red: 255, green: 255, blue: 255, alpha: 255)
    MAGENTA     = Types::Color.new(red: 255, green: 0, blue: 255, alpha: 255)
    RAY_WHITE   = Types::Color.new(red: 245, green: 245, blue: 245, alpha: 255)
  end
end
