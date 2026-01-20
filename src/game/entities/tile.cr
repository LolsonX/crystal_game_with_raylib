class Tile
  include Drawable
  include Game::Entities::Eventable

  property x : Int32
  property y : Int32
  property color : CrystalRaylib::Types::Color

  HEIGHT = 128
  WIDTH  = 128

  VELOCITY = 100

  def initialize(@x : Int32, @y : Int32, @color = CrystalRaylib::Types::Color.new(red: 200, green: 31, blue: 31, alpha: 255))
  end

  def draw
    triangles.each do |(v3, v2, v1)|
      CrystalRaylib::Shapes.draw_triangle(vertex_1: v1, vertex_2: v2, vertex_3: v3, color: color)
    end
  end

  def triangles
    v1, v2, v3, v4 = vertices
    [
      [
        v1, v2, v3,
      ],
      [
        v3, v4, v1,
      ],
    ]
  end

  def vertices
    {
      CrystalRaylib::Types::Vector2.new(x: (iso_x + WIDTH // 2).to_f32, y: iso_y.to_f32),
      CrystalRaylib::Types::Vector2.new(x: (iso_x + WIDTH).to_f32, y: (iso_y + HEIGHT // 4).to_f32),
      CrystalRaylib::Types::Vector2.new(x: (iso_x + WIDTH // 2).to_f32, y: (iso_y + HEIGHT // 2).to_f32),
      CrystalRaylib::Types::Vector2.new(x: iso_x.to_f32, y: (iso_y + HEIGHT // 4).to_f32),
    }
  end

  def iso_x
    (x - y) * WIDTH // 2
  end

  def iso_y
    (x + y) * HEIGHT // 4
  end

  def scale_vector(vector : CrystalRaylib::Types::Vector2, multiplier : Float32) : CrystalRaylib::Types::Vector2
    CrystalRaylib::Types::Vector2.new(x: vector.x * multiplier, y: vector.y * multiplier)
  end
end
