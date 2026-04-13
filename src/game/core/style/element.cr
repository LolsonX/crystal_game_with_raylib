require "./fill"
require "./border"

module Core
  module Styles
    struct Element
      getter fill : Fill
      getter border : Border

      def initialize(
        @fill : Fill = Fill.new,
        @border : Border = Border.new,
      )
      end

      def background_color : CrystalRaylib::Types::Color
        fill.color
      end

      def border_color : CrystalRaylib::Types::Color
        border.color
      end

      def border_thickness : Float32
        border.thickness
      end
    end
  end
end
