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

    def self.draw_triangle_fan(points : Array(Types::Vector2), color : Types::Color)
      lib_points = points.map(&.to_lib)
      LibRaylib.draw_triangle_fan(lib_points.to_unsafe, lib_points.size, color.to_lib)
    end

    def self.draw_line(start_pos : Types::Vector2, end_pos : Types::Vector2, thickness : Float32, color : Types::Color)
      LibRaylib.draw_line_ex(start_pos: start_pos.to_lib, end_pos: end_pos.to_lib, thickness: thickness, color: color.to_lib)
    end

    def self.draw_rectangle_lines(x : Int32, y : Int32, width : Int32, height : Int32, color : Types::Color)
      LibRaylib.draw_rectangle_lines(x, y, width, height, color.to_lib)
    end

    def self.draw_rectangle_lines_ex(x : Int32, y : Int32, width : Int32, height : Int32, line_thick : Float32, color : Types::Color)
      rec = LibRaylib::Rectangle.new(x: x.to_f32, y: y.to_f32, width: width.to_f32, height: height.to_f32)
      LibRaylib.draw_rectangle_lines_ex(rec, line_thick, color.to_lib)
    end
  end
end
