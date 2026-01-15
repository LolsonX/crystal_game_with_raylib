class GameMap
  getter width : Int32
  getter height : Int32
  getter tile_width : Int32
  getter tile_height : Int32

  def initialize(@width : Int32, @height : Int32, @tile_width : Int32 = 128, @tile_height : Int32 = 64)
    @tiles = Array(Tile?).new(width * height) { nil }
    create_checkerboard_pattern
  end

  def tile_at(x : Int32, y : Int32) : Tile?
    return nil if x < 0 || x >= @width || y < 0 || y >= @height
    @tiles[y * @width + x]?
  end

  def each_tile(&)
    @height.times do |y|
      @width.times do |x|
        yield tile_at(x, y)
      end
    end
  end

  def draw
    each_tile do |tile|
      tile.try(&.draw)
    end
  end

  private def create_checkerboard_pattern
    @height.times do |y|
      @width.times do |x|
        color = if (x % 2 == 1 && y % 2 == 0) || (x % 2 == 0 && y % 2 == 1)
                  CrystalRaylib::Colors::RED
                else
                  CrystalRaylib::Colors::GREEN
                end
        @tiles[y * @width + x] = Tile.new(x: x, y: y, color: color)
      end
    end
  end
end
