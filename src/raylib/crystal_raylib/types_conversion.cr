module CrystalRaylib
  module Types
    struct Color
      def to_lib : LibRaylib::Color
        LibRaylib::Color.new(r: @red, g: @green, b: @blue, a: @alpha)
      end

      def self.from_lib(lib_color : LibRaylib::Color)
        Color.new(red: lib_color.r, green: lib_color.g, blue: lib_color.b, alpha: lib_color.a)
      end
    end

    struct Vector2
      def to_lib : LibRaylib::Vector2
        LibRaylib::Vector2.new(x: @x, y: @y)
      end

      def self.from_lib(lib_vector : LibRaylib::Vector2)
        Vector2.new(x: lib_vector.x, y: lib_vector.y)
      end
    end

    struct Camera2D
      def to_lib : LibRaylib::Camera2D
        LibRaylib::Camera2D.new(offset: @offset.to_lib, target: @target.to_lib, rotation: @rotation, zoom: @zoom)
      end

      def self.from_lib(lib_camera : LibRaylib::Camera2D) : Camera2D
        Camera2D.new(
          offset: Vector2.from_lib(lib_camera.offset),
          target: Vector2.from_lib(lib_camera.target),
          rotation: lib_camera.rotation,
          zoom: lib_camera.zoom
        )
      end
    end
  end
end
