module CrystalRaylib
  module Text
    def self.draw_fps(x : Int32, y : Int32)
      LibRaylib.draw_fps(x: x, y: y)
    end

    def self.draw_text(text : String, x : Int32, y : Int32, size : Int32, color : Types::Color)
      LibRaylib.draw_text(text: text.to_unsafe, x: x, y: y, font_size: size, color: color.to_lib)
    end
  end
end
