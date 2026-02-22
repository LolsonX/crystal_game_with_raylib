require "../../spec_helper"

describe Entities::Tile do
  context "when initialized with coordinates" do
    it "sets the default color" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.color.red.should eq(200)
      tile.color.green.should eq(31)
      tile.color.blue.should eq(31)
    end

    it "accepts a custom color" do
      color = CrystalRaylib::Types::Color.new(red: 100, green: 150, blue: 200, alpha: 255)
      tile = Entities::Tile.new(x: 0, y: 0, color: color)

      tile.color.should eq(color)
    end
  end

  context "when converting grid position to isometric x coordinate" do
    it "returns 0 for the origin (0, 0)" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.iso_x.should eq(0)
    end

    it "calculates correctly for positive coordinates where x > y" do
      tile = Entities::Tile.new(x: 3, y: 1)
      expected = (3 - 1) * Entities::Tile::WIDTH // 2

      tile.iso_x.should eq(expected)
    end

    it "calculates correctly for positive coordinates where y > x" do
      tile = Entities::Tile.new(x: 1, y: 3)
      expected = (1 - 3) * Entities::Tile::WIDTH // 2

      tile.iso_x.should eq(expected)
    end
  end

  context "when converting grid position to isometric y coordinate" do
    it "returns 0 for the origin (0, 0)" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.iso_y.should eq(0)
    end

    it "calculates correctly as the sum of coordinates scaled by half height" do
      tile = Entities::Tile.new(x: 2, y: 3)
      expected = (2 + 3) * Entities::Tile::HEIGHT // 2

      tile.iso_y.should eq(expected)
    end
  end

  context "when generating geometry vertices" do
    it "returns 4 vertices forming a diamond shape" do
      tile = Entities::Tile.new(x: 0, y: 0)
      vertices = tile.vertices

      vertices.size.should eq(4)
    end

    it "returns consistent vertices across multiple calls" do
      tile = Entities::Tile.new(x: 0, y: 0)
      v1 = tile.vertices
      v2 = tile.vertices

      v1.should eq(v2)
    end
  end

  context "when generating triangles" do
    it "returns 2 triangles" do
      tile = Entities::Tile.new(x: 0, y: 0)
      triangles = tile.triangles

      triangles.size.should eq(2)
      triangles.each(&.size.should(eq(3)))
    end

    it "returns consistent triangles across multiple calls" do
      tile = Entities::Tile.new(x: 0, y: 0)
      t1 = tile.triangles
      t2 = tile.triangles

      t1.should eq(t2)
    end
  end

  context "when generating outline segments" do
    it "returns 4 line segments" do
      tile = Entities::Tile.new(x: 0, y: 0)
      outline = tile.outline

      outline.size.should eq(4)
      outline.each(&.size.should(eq(2)))
    end

    it "returns consistent outline across multiple calls" do
      tile = Entities::Tile.new(x: 0, y: 0)
      o1 = tile.outline
      o2 = tile.outline

      o1.should eq(o2)
    end
  end

  context "when comparing two tiles" do
    it "considers tiles equal when coordinates match" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 3, y: 5)

      tile1.should eq(tile2)
    end

    it "considers tiles unequal when x differs" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 4, y: 5)

      tile1.should_not eq(tile2)
    end

    it "considers tiles unequal when y differs" do
      tile1 = Entities::Tile.new(x: 3, y: 5)
      tile2 = Entities::Tile.new(x: 3, y: 6)

      tile1.should_not eq(tile2)
    end

    it "considers any tile unequal to nil" do
      tile = Entities::Tile.new(x: 0, y: 0)

      tile.should_not eq(nil)
    end
  end

  context "given the WIDTH and HEIGHT constants" do
    it "defines HEIGHT as half of WIDTH" do
      Entities::Tile::HEIGHT.should eq(Entities::Tile::WIDTH // 2)
    end
  end
end
