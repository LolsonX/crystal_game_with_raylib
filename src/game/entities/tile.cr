class Tile
  property x : Int32
  property y : Int32
  property color : CrystalRaylib::Color

  HEIGHT = 128
  WIDTH  = 128

  VELOCITY = 100

  def initialize(@x : Int32, @y : Int32, @color = CrystalRaylib::Color.new(r: 200, g: 31, b: 31, a: 255))
  end

  def draw
    triangles.each do |(v3, v2, v1)|
      CrystalRaylib.draw_triangle(vertex_1: v1, vertex_2: v2, vertex_3: v3, color: color)
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
      CrystalRaylib::Vector2.new(x: iso_x + WIDTH // 2, y: iso_y),
      CrystalRaylib::Vector2.new(x: iso_x + WIDTH, y: iso_y + HEIGHT // 4),
      CrystalRaylib::Vector2.new(x: iso_x + WIDTH // 2, y: iso_y + HEIGHT // 2),
      CrystalRaylib::Vector2.new(x: iso_x, y: iso_y + HEIGHT // 4),
    }
  end

  def iso_x
    (x - y) * WIDTH // 2
  end

  def iso_y
    (x + y) * HEIGHT // 4
  end

  def scale_vector(vector : Vector2, multiplier : Float32) : Vector2
    CrystalRaylib::Vector2.new(x: vector.x * multiplier, y: vector.y * multiplier)
  end
end
