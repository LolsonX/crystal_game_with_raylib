module Entities
  class Tile
    include Traits::Eventable

    alias Vector2 = CrystalRaylib::Types::Vector2
    alias Color = CrystalRaylib::Types::Color

    property x : Int32
    property y : Int32

    @triangles : Array(Array(Vector2))?
    @outline : Array(Array(Vector2))?
    property color : CrystalRaylib::Types::Color

    WIDTH  = 128
    HEIGHT = WIDTH // 2

    OUTLINE_COLOR = CrystalRaylib::Colors::RED

    VELOCITY = 100

    def initialize(@x : Int32, @y : Int32, @color = Color.new(red: 200, green: 31, blue: 31, alpha: 255))
    end

    def draw(with_outline : Bool)
      triangles.each do |(v3, v2, v1)|
        CrystalRaylib::Shapes.draw_triangle(vertex_1: v1, vertex_2: v2, vertex_3: v3, color: color)
      end
      draw_outline if with_outline
    end

    def triangles : Array(Array(Vector2))
      if triangles = @triangles
        return triangles
      else
        v1, v2, v3, v4 = vertices
        @triangles ||= [
          [
            v3, v1, v2,
          ],
          [
            v3, v4, v1,
          ],
        ]
      end
    end

    def draw_outline
      outline.each do |(start_pos, end_pos)|
        CrystalRaylib::Shapes.draw_line(start_pos: start_pos, end_pos: end_pos, thickness: 6_f32, color: OUTLINE_COLOR)
      end
    end

    def outline : Array(Array(Vector2))
      if (outline = @outline)
        return outline
      else
        v1, v2, v3, v4 = vertices
        @outline ||= [
          [v1, v2],
          [v2, v3],
          [v3, v4],
          [v4, v1],
        ]
      end
    end

    def vertices
      @vertices ||= {
        Vector2.new(x: (iso_x + WIDTH // 2).to_f32, y: iso_y.to_f32),
        Vector2.new(x: (iso_x + WIDTH).to_f32, y: (iso_y + HEIGHT // 2).to_f32),
        Vector2.new(x: (iso_x + WIDTH // 2).to_f32, y: (iso_y + HEIGHT).to_f32),
        Vector2.new(x: iso_x.to_f32, y: (iso_y + HEIGHT // 2).to_f32),
      }
    end

    def iso_x
      (x - y) * WIDTH // 2
    end

    def iso_y
      (x + y) * HEIGHT // 2
    end

    def scale_vector(vector : Vector2, multiplier : Float32) : Vector2
      Vector2.new(x: vector.x * multiplier, y: vector.y * multiplier)
    end

    def ==(tile)
      if other_tile = tile
        x == other_tile.x && y == other_tile.y
      else
        false
      end
    end
  end
end
