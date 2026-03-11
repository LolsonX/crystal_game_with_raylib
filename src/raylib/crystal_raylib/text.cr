module CrystalRaylib
  module Text
    def self.draw_fps(x : Int32, y : Int32)
      LibRaylib.draw_fps(x: x, y: y)
    end

    def self.draw_text(text : String, x : Int32, y : Int32, size : Int32, color : Types::Color)
      LibRaylib.draw_text(text: text.to_unsafe, x: x, y: y, font_size: size, color: color.to_lib)
    end

    def self.measure(text : String, font_size : Int32) : Int32
      LibRaylib.measure_text(text.to_unsafe, font_size)
    end
  end
end
