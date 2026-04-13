module Core
  module Styles
    struct Border
      getter color : CrystalRaylib::Types::Color
      getter thickness : Float32

      def initialize(
        @color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
        @thickness : Float32 = 2.0_f32,
      )
      end
    end
  end
end
