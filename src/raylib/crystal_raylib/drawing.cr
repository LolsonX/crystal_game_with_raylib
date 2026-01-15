module CrystalRaylib
  module Drawing
    def self.begin_drawing
      LibRaylib.begin_drawing
    end

    def self.clear_background(color : Types::Color)
      LibRaylib.clear_background(color.to_lib)
    end

    def self.draw(&)
      begin_drawing()
      yield
      end_drawing()
    end

    def self.end_drawing
      LibRaylib.end_drawing
    end
  end
end
