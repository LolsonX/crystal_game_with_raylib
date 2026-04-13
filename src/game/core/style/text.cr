module Core
  module Styles
    struct Text
      getter color : CrystalRaylib::Types::Color
      getter size : Int32

      def initialize(
        @color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
        @size : Int32 = 18,
      )
      end
    end
  end
end
