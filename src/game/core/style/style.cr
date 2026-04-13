require "./fill"
require "./border"
require "./text"
require "./element"

module Core
  struct Style
    getter background : Styles::Fill
    getter border : Styles::Border
    getter text : Styles::Text
    getter category_fill : Styles::Fill?
    getter hover_color : CrystalRaylib::Types::Color?
    getter pressed_color : CrystalRaylib::Types::Color?

    def initialize(
      @background : Styles::Fill = Styles::Fill.new,
      @border : Styles::Border = Styles::Border.new,
      @text : Styles::Text = Styles::Text.new(size: 20),
      @category_fill : Styles::Fill? = nil,
      @hover_color : CrystalRaylib::Types::Color? = nil,
      @pressed_color : CrystalRaylib::Types::Color? = nil,
    )
    end

    def background_color : CrystalRaylib::Types::Color
      background.color
    end

    def border_color : CrystalRaylib::Types::Color
      border.color
    end

    def outline_color : CrystalRaylib::Types::Color
      border.color
    end

    def outline_thickness : Float32
      border.thickness
    end

    def text_color : CrystalRaylib::Types::Color
      text.color
    end

    def font_size : Int32
      text.size
    end

    def category_color : CrystalRaylib::Types::Color
      category_fill.try(&.color) || CrystalRaylib::Colors::LIGHT_GRAY
    end
  end
end
