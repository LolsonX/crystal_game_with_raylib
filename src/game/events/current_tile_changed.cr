module Events
  class CurrentTileChanged < Base
    getter tile : Entities::Tile?

    def initialize(@tile)
    end
  end
end
