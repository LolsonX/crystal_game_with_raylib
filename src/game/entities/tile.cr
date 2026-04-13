module Entities
  class Tile
    alias Vector2 = CrystalRaylib::Types::Vector2

    property x : Int32
    property y : Int32
    property fill_color : Core::Styles::Fill
    property outline : Core::Styles::Border

    WIDTH  = 128
    HEIGHT = WIDTH // 2

    @triangles : Array(Array(Vector2))?
    @outline_vertices : Array(Array(Vector2))?

    def initialize(
      @x : Int32,
      @y : Int32,
      fill_color : CrystalRaylib::Types::Color = CrystalRaylib::Types::Color.new(red: 40, green: 40, blue: 40, alpha: 255),
    )
      @fill_color = Core::Styles::Fill.new(color: fill_color)
      @outline = Core::Styles::Border.new(color: CrystalRaylib::Colors::WHITE, thickness: 2.0_f32)
    end

    def draw(with_outline : Bool)
      triangles.each do |(v3, v2, v1)|
        CrystalRaylib::Shapes.draw_triangle(vertex_1: v1, vertex_2: v2, vertex_3: v3, color: fill_color.color)
      end
      draw_outline if with_outline
    end

    def triangles : Array(Array(Vector2))
      if triangles = @triangles
        triangles
      else
        v1, v2, v3, v4 = vertices
        @triangles ||= [
          [v3, v1, v2],
          [v3, v4, v1],
        ]
      end
    end

    def draw_outline
      outline_vertices.each do |(start_pos, end_pos)|
        CrystalRaylib::Shapes.draw_line(
          start_pos: start_pos,
          end_pos: end_pos,
          thickness: outline.thickness,
          color: outline.color
        )
      end
    end

    def outline_vertices : Array(Array(Vector2))
      if outline = @outline_vertices
        outline
      else
        v1, v2, v3, v4 = vertices
        @outline_vertices ||= [
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

    def ==(other : Tile?) : Bool
      return false unless other
      x == other.x && y == other.y
    end
  end
end
