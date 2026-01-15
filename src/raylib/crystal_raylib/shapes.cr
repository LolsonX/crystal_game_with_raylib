module CrystalRaylib
  module Shapes
    def self.draw_polygon(center : Types::Vector2, sides : Int32, radius : Float32, rotation : Float32, color : Types::Color)
      LibRaylib.draw_polygon(center.to_lib, sides, radius, rotation, color.to_lib)
    end

    def self.draw_rectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Types::Color)
      LibRaylib.draw_rectangle(x, y, width, height, color.to_lib)
    end

    def self.draw_triangle(vertex_1 : Types::Vector2, vertex_2 : Types::Vector2, vertex_3 : Types::Vector2, color : Types::Color)
      LibRaylib.draw_triangle(vertex_1.to_lib, vertex_2.to_lib, vertex_3.to_lib, color.to_lib)
    end

    def self.draw_triangle_fan(points : Array(Types::Vector2), point_count : Int32, color : Types::Color)
      points_ptr = points.map(&.to_lib).to_unsafe
      LibRaylib.draw_triangle_fan(points_ptr, point_count, color.to_lib)
    end
  end
end
