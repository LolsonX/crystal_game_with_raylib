require "../../spec_helper"

describe Events::CurrentTileChanged do
  context "when initialized with a tile" do
    it "stores the tile" do
      tile = Entities::Tile.new(x: 5, y: 10)
      event = Events::CurrentTileChanged.new(tile: tile)

      event.tile.should eq(tile)
    end
  end

  context "when initialized with nil" do
    it "stores nil as the tile" do
      event = Events::CurrentTileChanged.new(tile: nil)

      event.tile.should be_nil
    end
  end
end
