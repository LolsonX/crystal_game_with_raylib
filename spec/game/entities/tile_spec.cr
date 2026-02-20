require "../../spec_helper"

describe Entities::Tile do
  describe "#initialize" do
    it "sets x and y coordinates" do
      tile = Entities::Tile.new(x: 5, y: 10)

      tile.x.should eq(5)
      tile.y.should eq(10)
    end

    it "sets default color" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.color.red.should eq(200)
      tile.color.green.should eq(31)
      tile.color.blue.should eq(31)
    end

    it "accepts custom color" do
      color = CrystalRaylib::Types::Color.new(red: 100, green: 150, blue: 200, alpha: 255)
      tile = Entities::Tile.new(x: 0, y: 0, color: color)

      tile.color.should eq(color)
    end
  end

  describe "#iso_x" do
    it "converts grid x=0, y=0 to iso_x=0" do
      tile = Entities::Tile.new(x: 0, y: 0)
      tile.iso_x.should eq(0)
    end

    it "converts grid coordinates correctly for positive values" do
      tile = Entities::Tile.new(x: 2, y: 1)
      expected = (2 - 1) * Entities::Tile::WIDTH // 2
      tile.iso_x.should eq(expected)
    end

    it "converts grid coordinates correctly for x > y" do
      tile = Entities::Tile.new(x: 3, y: 1)
      expected = (3 - 1) * Entities::Tile::WIDTH // 2
      tile.iso_x.should eq(expected)
    end

    it "converts grid coordinates correctly for y > x" do
      tile = Entities::Tile.new(x: 1, y: 3)
      expected = (1 - 3) * Entities::Tile::WIDTH // 2
      tile.iso_x.should eq(expected)
    end
  end

  describe "#iso_y" do
    it "converts grid x=0, y=0 to iso_y=0" do
      tile = Entities::Tile.new(x: 0, y: 0)
      tile.iso_y.should eq(0)
    end

    it "converts grid coordinates correctly" do
      tile = Entities::Tile.new(x: 2, y: 3)
      expected = (2 + 3) * Entities::Tile::HEIGHT // 2
      tile.iso_y.should eq(expected)
    end
  end

  describe "#vertices" do
    it "returns 4 vertices" do
      tile = Entities::Tile.new(x: 0, y: 0)
      vertices = tile.vertices

      vertices.size.should eq(4)
    end

    it "returns consistent vertices" do
      tile = Entities::Tile.new(x: 0, y: 0)
      v1 = tile.vertices
      v2 = tile.vertices

      v1.should eq(v2)
    end
  end

  describe "#triangles" do
    it "returns 2 triangles" do
      tile = Entities::Tile.new(x: 0, y: 0)
      triangles = tile.triangles

      triangles.size.should eq(2)
      triangles.each(&.size.should(eq(3)))
    end

    it "returns consistent triangles" do
      tile = Entities::Tile.new(x: 0, y: 0)
      t1 = tile.triangles
      t2 = tile.triangles

      t1.should eq(t2)
    end
  end

  describe "#outline" do
    it "returns 4 line segments" do
      tile = Entities::Tile.new(x: 0, y: 0)
      outline = tile.outline

      outline.size.should eq(4)
      outline.each(&.size.should(eq(2)))
    end

    it "returns consistent outline" do
      tile = Entities::Tile.new(x: 0, y: 0)
      o1 = tile.outline
      o2 = tile.outline

      o1.should eq(o2)
    end
  end

  describe "#==" do
    it "returns true for same x and y" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 3, y: 5)

      tile1.should eq(tile2)
    end

    it "returns false for different x" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 4, y: 5)

      tile1.should_not eq(tile2)
    end

    it "returns false for different y" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 3, y: 6)

      tile1.should_not eq(tile2)
    end

    it "returns false for nil" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.should_not eq(nil)
    end
  end

  describe "WIDTH and HEIGHT constants" do
    it "HEIGHT is half of WIDTH" do
      Entities::Tile::HEIGHT.should eq(Entities::Tile::WIDTH // 2)
    end
  end
end
