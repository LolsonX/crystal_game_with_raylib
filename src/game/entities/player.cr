class Player
  property x : Int32
  property y : Int32
  property color : CrystalRaylib::Color

  HEIGHT = 30
  WIDTH = 40

  VELOCITY = 100

  def initialize(@x : Int32, @y : Int32, @color = CrystalRaylib::Color.new(r: 200, g: 31, b: 31, a: 255))
  end

  def draw
    CrystalRaylib.draw_rectangle(x: x - (WIDTH // 2), y: y - (HEIGHT // 2), width: WIDTH, height: HEIGHT, color: color)
  end
end
